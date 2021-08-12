#include "axi_apiv1.h"

void dma::dma_init(unsigned int _dma_address, unsigned int _dma_input_address,  unsigned int _dma_input_buffer_size,  unsigned int _dma_output_address,  unsigned int _dma_output_buffer_size){
    int dh = open("/dev/mem", O_RDWR | O_SYNC);

    void *dma_mm = mmap(NULL, 65536, PROT_READ | PROT_WRITE, MAP_SHARED, dh, _dma_address); // Memory map AXI Lite register block
    void *dma_in_mm  = mmap(NULL, _dma_input_buffer_size, PROT_READ | PROT_WRITE, MAP_SHARED, dh, _dma_input_address); // Memory map source address
    void *dma_out_mm = mmap(NULL, _dma_output_buffer_size, PROT_READ, MAP_SHARED, dh, _dma_output_address); // Memory map destination address
    dma_address = reinterpret_cast<unsigned int*> (dma_mm);
    dma_input_address = reinterpret_cast<unsigned int*> (dma_in_mm);
    dma_output_address = reinterpret_cast<unsigned int*> (dma_out_mm);
    dma_input_buffer_size = _dma_input_buffer_size;
    dma_output_buffer_size = _dma_output_buffer_size;
    close(dh);
    initDMAControls();
}

void dma::dma_free(){
    munmap(dma_input_address,dma_input_buffer_size/4);
    munmap(dma_output_address,dma_output_buffer_size/4);
    munmap(dma_address,65536/4);
}

// We could reduce to one set of the following calls
//================================================================================================================
unsigned int* dma::dma_get_inbuffer(){
    return dma_input_address;
}

unsigned int* dma::dma_get_outbuffer(){
    return dma_output_address;
}
//================================================================================================================
int dma::dma_copy_to_inbuffer(unsigned int* src_address, int data_length, int offset){
    assert(("data copy will overflow input buffer",offset+data_length <=dma_input_buffer_size));
    std::memcpy( &src_address, &dma_input_address+offset, sizeof(data_length));
}

int dma::dma_copy_from_outbuffer(unsigned int* dst_address, int data_length, int offset){
    assert(("tries to access data outwith the output buffer",offset+data_length <=dma_output_buffer_size));
    std::memcpy( &dma_input_address+offset, &dst_address, sizeof(data_length));
}
//================================================================================================================

int dma::dma_start_send(int length, int offset){
    assert(("trying to send data outside the input buffer",offset+length <=dma_input_buffer_size));
    dma_set(dma_address, MM2S_START_ADDRESS, (unsigned long) dma_input_address+offset);
    dma_set(dma_address, MM2S_LENGTH, length);
    LOG("Transfer Started");
}

void dma::dma_wait_send(){
    dma_mm2s_sync();
    LOG("Data Transfer - Done");
}

int dma::dma_check_send(){
    unsigned int mm2s_status = dma_get(dma_address, MM2S_STATUS_REGISTER);
    bool done = !((!(mm2s_status & 1<<12)) || (!(mm2s_status & 1<<1)));
    if(done)LOG("Data Transfer - Done");
    else LOG("Data Transfer - Not Done");
    return done?0:-1;
}

int dma::dma_start_recv(int length , int offset){
    assert(("trying receive data outside the output buffer",offset+length <=dma_output_buffer_size));
    dma_set(dma_address, S2MM_DESTINATION_ADDRESS, (unsigned long) dma_output_address+offset);
    dma_set(dma_address, S2MM_LENGTH,length);
    LOG("Started Receiving");
}

void dma::dma_wait_recv(){
    dma_s2mm_sync();
    LOG("Data Receive - Done");
}

int dma::dma_check_recv(){
    unsigned int s2mm_status = dma_get(dma_address, S2MM_STATUS_REGISTER);
    bool done = !((!(s2mm_status & 1<<12)) || (!(s2mm_status & 1<<1)));
    if(done) LOG("Data Receive - Done");
    else LOG("Data Receive - Not Done");
    return done?0:-1;
}


//********************************** Unexposed Functions **********************************
void dma::initDMAControls(){
    dma_set(dma_address, S2MM_CONTROL_REGISTER, 4);
    dma_set(dma_address, MM2S_CONTROL_REGISTER, 4);
    dma_set(dma_address, S2MM_CONTROL_REGISTER, 0);
    dma_set(dma_address, MM2S_CONTROL_REGISTER, 0);
    dma_set(dma_address, S2MM_DESTINATION_ADDRESS, (unsigned long) dma_output_address); // Write destination address
    dma_set(dma_address, MM2S_START_ADDRESS, (unsigned long) dma_input_address); // Write source address
    dma_set(dma_address, S2MM_CONTROL_REGISTER, 0xf001);
    dma_set(dma_address, MM2S_CONTROL_REGISTER, 0xf001);
}

unsigned int dma::dma_set(unsigned int* dma_address, int offset, unsigned int value) {
    dma_address[offset>>2] = value;
}

unsigned int dma::dma_get(unsigned int* dma_address, int offset) {
    return dma_address[offset>>2];
}


int dma::dma_mm2s_sync() {
    msync(dma_address,PAGE_SIZE,MS_SYNC);
    unsigned int mm2s_status =  dma_get(dma_address, MM2S_STATUS_REGISTER);
    while(!(mm2s_status & 1<<12) || !(mm2s_status & 1<<1) ){
        msync(dma_address,PAGE_SIZE,MS_SYNC);
        mm2s_status =  dma_get(dma_address, MM2S_STATUS_REGISTER);
    }
}

int dma::dma_s2mm_sync() {
    msync(dma_address,PAGE_SIZE,MS_SYNC);
    unsigned int s2mm_status = dma_get(dma_address, S2MM_STATUS_REGISTER);
    while(!(s2mm_status & 1<<12) || !(s2mm_status & 1<<1)){
        msync(dma_address,PAGE_SIZE,MS_SYNC);     
        s2mm_status = dma_get(dma_address, S2MM_STATUS_REGISTER);
    }
}

void dma::acc_init(unsigned int base_addr,int length){
    int dh = open("/dev/mem", O_RDWR | O_SYNC);
    size_t virt_base = base_addr & ~(PAGE_SIZE - 1);
    size_t virt_offset = base_addr - virt_base;
    void *addr =mmap(NULL,length+virt_offset,PROT_READ | PROT_WRITE,MAP_SHARED,dh,virt_base);
    close(dh);
    if (addr == (void*) -1 ) exit (EXIT_FAILURE);
    acc_address = reinterpret_cast<unsigned int*> (addr);
}


void dma::dump_acc_signals(int state) {
    msync(acc_address,PAGE_SIZE,MS_SYNC);
    std::ofstream file;
    file.open("dump_acc_signals.dat", std::ios_base::app);
    file<< "====================================================" << std::endl;
    file << "State: " << state << std::endl;
    file<< "====================================================" << std::endl;
    for(int i=0;i<16;i++)file<< acc_address[i] << ",";
    file<< "====================================================" << std::endl;
}