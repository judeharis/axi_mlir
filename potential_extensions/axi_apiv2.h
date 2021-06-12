#ifndef AXI_APIv2
#define AXI_APIv2

// API Model = Each DMA knows start to end memory addresses it can access, buffers created when required for given dma

//TODO: Struct based representation of API model

//-----------------DMA Functions-----------------
/** 
 * Memory maps dma_count amount of DMAs
 * dma_address, dma_start, dma_end should have dma_count amount of elements
 * dma_address contains array of base addresses for each dma
 * dma_start contains array of starting memory location which each dma can accesss
 * dma_end contains array of ending memory location which each dma can accesss
 * memory maps each dma's base address
 * runs starting controls signals and sets MMS2, S2MM address registers to start memory locations for each dma
 */
void dma_init(int dma_count, unsigned int* dma_address, unsigned int* dma_start, unsigned int* dma_end);

// Memory unmaps DMA base addresses
void dma_free();

//Get base address for dma represented by dma_id,
unsigned int* dma_get_regaddr(int id);




//-----------------BUFFER Functions-----------------
/** 
 * Memory maps dma_buffer for the dma represented by dma_id.
 * Size of buffer is specified by length in bytes.
 * Returns ID for the buffer.
 * If unable to allocate block of contiguous memory of the given length then return -1
 * Records space taken from the DMA_memory space.
 * Records which dma_id
 * Records MMap address of buffer
 */
int dma_init_buffer(int dma_id,int length);

// Memory unmaps buffer associated with the buffer_id
void dma_free_buffer(int buffer_id);

// Get the MMap address of the buffer associated with the buffer_id
unsigned int* dma_get_buffer(int buffer_id);




//-----------------DMA MMS2 Functions-----------------
/** 
 * Gets base address of dma using dma_id
 * Gets base address of buffer using buffer_id
 * Checks if buffer size is >= length
 * Sets the dma MMS2 starting address to base address of buffer
 * Sets MMS2 transfer length to length
 * Starts transfers to the accelerator using dma associated with dma_id
 * Return 0 if successful, returns negative if error occurs
 */
int dma_set_transfer(int dma_id,int buffer_id, int length);

//Blocks thread until dma MMS2 transfer is complete
void dma_send(int dma_id,int buffer_id, int length);

// Same as dma_send but thread does not block, returns if 0
int dma_send_nb(int dma_id,int buffer_id, int length);




//-----------------DMA S2MM Functions-----------------
/** 
 * Gets base address of dma using dma_id
 * Gets base address of buffer using buffer_id
 * Checks if buffer size is >= length
 * Sets the dma S2MM starting address to base address of buffer
 * Sets 2SMM store length
 * Starts storing data recieved through dma associated with dma_id
 * Return 0 if successful, returns negative if error occurs
 */
int dma_set_store(int dma_id,int buffer_id, int length);

//Blocks thread until dma S2MM transfer is complete (TLAST signal is seen)
void dma_recv(int dma_id,int buffer_id, int length);

// Same as dma_recv but thread does not block, returns if 0
int dma_recv_nb(int dma_id,int buffer_id, int length);

#endif