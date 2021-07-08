#ifndef AXI_APIv1
#define AXI_APIv1

// API Model = Each DMA is allocated one input and one output buffer, calling the init functions initates all buffers

//TODO: Struct based representation of API model

//-----------------DMA Functions-----------------
/** 
 * Memory maps dma_count amount of DMAs
 * dma_address, dma_input_addrs, dma_input_lens, dma_output_addrs, dma_output_lens  should have dma_count amount of elements
 * dma_address contains array of base addresses for each dma
 * dma_input_addrs contains starting memory locations for dma input buffers, dma_input_lens contains lengths of the buffers
 * dma_output_addrs contains starting memory locations for dma output buffers, dma_output_lens contains lengths of the buffers
 * memory maps each dma's base address
 * runs starting controls signals and sets MMS2, S2MM address registers to start memory locations of the input and output buffers
 */
void dma_init(int dma_count, unsigned int* dma_address, unsigned int* dma_input_addrs,  unsigned int* dma_input_lens,  unsigned int* dma_output_addrs,  unsigned int* dma_output_lens);

// Memory unmaps DMA base addresses and Input and output buffers
void dma_free();

//Get base address for dma represented by dma_id,
unsigned int* dma_get_regaddr(int id);




//-----------------BUFFER Functions-----------------
// Get the MMap address of the input buffer of dma associated with dma_id
unsigned int* dma_get_inbuffer(int dma_id);

// Get the MMap address of the output buffer of dma associated with dma_id
unsigned int* dma_get_outbuffer(int dma_id);




//-----------------DMA MMS2 Functions-----------------
/** 
 * Checks if input buffer size is >= length
 * Sets DMA MMS2 transfer length to length
 * Starts transfers to the accelerator using dma associated with dma_id
 * Return 0 if successful, returns negative if error occurs
 */
int dma_set_transfer(int dma_id, int length);

//Blocks thread until dma MMS2 transfer is complete
void dma_send(int dma_id,int buffer_ID, int length);

// Same as dma_send but thread does not block, returns if 0
int dma_send_nb(int dma_id,int buffer_ID, int length);




//-----------------DMA S2MM Functions-----------------
/** 
 * Checks if buffer size is >= length
 * Sets 2SMM store length
 * Starts storing data recieved through dma associated with dma_id
 * Return 0 if successful, returns negative if error occurs
 */
int dma_set_store(int dma_id,int buffer_ID, int length);

//Blocks thread until dma S2MM transfer is complete (TLAST signal is seen)
void dma_recv(int dma_id,int buffer_ID, int length);

// Same as dma_recv but thread does not block, returns if 0
int dma_recv_nb(int dma_id,int buffer_ID, int length);

#endif


    //Ignore
    // input_buffer_address : unsigned int         # Adddress to the start of the MMapped Input buffer
    // output_buffer_address : unsigned int        # Adddress to the start of the MMapped Output buffer
    // input_buffer_size : unsigned int            # Size of Input buffer
    // output_buffer_size : unsigned int           # Size of Output buffer