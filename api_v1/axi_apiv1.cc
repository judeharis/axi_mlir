#include "axi_apiv1.h"


void dma::dma_init(unsigned int _dma_address, unsigned int _dma_input_address,  unsigned int _dma_input_buffer_size,  unsigned int _dma_output_address,  unsigned int _dma_output_buffer_size){
    int dh = open("/dev/mem", O_RDWR | O_SYNC); // Open /dev/mem which represents the whole physical memory

    void *dma_mm = mmap(NULL, 65536, PROT_READ | PROT_WRITE, MAP_SHARED, dh, _dma_address); // Memory map AXI Lite register block
    void *dma_in_mm  = mmap(NULL, _dma_input_buffer_size, PROT_READ | PROT_WRITE, MAP_SHARED, dh, _dma_input_address); // Memory map source address
    void *dma_out_mm = mmap(NULL, _dma_output_buffer_size, PROT_READ, MAP_SHARED, dh, _dma_output_address); // Memory map destination address
    dma_address = reinterpret_cast<unsigned int*> (dma_mm);
    dma_input_address = reinterpret_cast<unsigned int*> (dma_in_mm);
    dma_output_address = reinterpret_cast<unsigned int*> (dma_out_mm);
    dma_input_buffer_size = _dma_input_buffer_size;
    dma_output_buffer_size = _dma_output_buffer_size;

    dma_set(dma_address, S2MM_CONTROL_REGISTER, 4);
    dma_set(dma_address, MM2S_CONTROL_REGISTER, 4);
    dma_set(dma_address, S2MM_CONTROL_REGISTER, 0);
    dma_set(dma_address, MM2S_CONTROL_REGISTER, 0);
    dma_set(dma_address, S2MM_DESTINATION_ADDRESS, (unsigned int) dma_output_address); // Write destination address
    dma_set(dma_address, MM2S_START_ADDRESS, (unsigned int) dma_input_address); // Write source address
    dma_set(dma_address, S2MM_CONTROL_REGISTER, 0xf001);
    dma_set(dma_address, MM2S_CONTROL_REGISTER, 0xf001);

      
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
    //TODO
}

int dma::dma_copy_from_outbuffer(unsigned int* dst_address, int data_length, int offset){
    //TODO
}
//================================================================================================================





int dma::dma_set_transfer(int length, int offset){
    //TODO
}


void dma::dma_send(){
    //TODO
}


int dma::dma_send_nb(){
    //TODO
}


int dma::dma_set_store(int length){
    //TODO
}


void dma::dma_recv(){
    //TODO
}


int dma::dma_recv_nb(){
    //TODO
}





//Unexposed to MLIR
unsigned int dma::dma_set(unsigned int* dma_virtual_address, int offset, unsigned int value) {
    dma_virtual_address[offset>>2] = value;
}

//Unexposed to MLIR
unsigned int dma::dma_get(unsigned int* dma_virtual_address, int offset) {
    return dma_virtual_address[offset>>2];
}