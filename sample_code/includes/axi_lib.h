#ifndef AXI_LIB
#define AXI_LIB

#include <sys/mman.h>
#include <iostream>

#define MM2S_CONTROL_REGISTER 0x00
#define MM2S_STATUS_REGISTER 0x04
#define MM2S_START_ADDRESS 0x18
#define MM2S_LENGTH 0x28

#define S2MM_CONTROL_REGISTER 0x30
#define S2MM_STATUS_REGISTER 0x34
#define S2MM_DESTINATION_ADDRESS 0x48
#define S2MM_LENGTH 0x58


template <typename Integer>
unsigned int dma_set(unsigned int* dma_virtual_address, int offset, unsigned int value) {
    dma_virtual_address[offset>>2] = value;
}

template <typename Integer>
unsigned int dma_get(unsigned int* dma_virtual_address, int offset) {
    return dma_virtual_address[offset>>2];
}

template <typename Integer>
void dma_s2mm_status(unsigned int* dma_virtual_address) {
    unsigned int status = dma_get<int>(dma_virtual_address, S2MM_STATUS_REGISTER);
    printf("");
}

template <typename Integer>
void dma_mm2s_status(unsigned int* dma_virtual_address) {
    unsigned int status = dma_get<int>(dma_virtual_address, MM2S_STATUS_REGISTER);
    printf("");
}


template <typename Integer>
int dma_mm2s_sync(unsigned int* dma_virtual_address) {
    msync(dma_virtual_address,88,MS_SYNC);
    unsigned int mm2s_status =  dma_get<int>(dma_virtual_address, MM2S_STATUS_REGISTER);
    while(!(mm2s_status & 1<<12) || !(mm2s_status & 1<<1) ){
        dma_s2mm_status<int>(dma_virtual_address);
        dma_mm2s_status<int>(dma_virtual_address);
        mm2s_status =  dma_get<int>(dma_virtual_address, MM2S_STATUS_REGISTER);

    }
}

template <typename Integer>
int dma_s2mm_sync(unsigned int* dma_virtual_address) {
    msync(dma_virtual_address,88,MS_SYNC);
    unsigned int s2mm_status = dma_get<int>(dma_virtual_address, S2MM_STATUS_REGISTER);
    while(!(s2mm_status & 1<<12) || !(s2mm_status & 1<<1)){
        dma_s2mm_status<int>(dma_virtual_address);
        dma_mm2s_status<int>(dma_virtual_address);      
        s2mm_status = dma_get<int>(dma_virtual_address, S2MM_STATUS_REGISTER);
    }
}

// template <typename Integer>
// int dma_change_start(unsigned int* dma0, unsigned int* dma1, unsigned int* dma2, unsigned int* dma3,int offset) {
//     dma_set<int>(dma0, MM2S_START_ADDRESS, 0x16000000+offset); // Write source address
//     dma_set<int>(dma1, MM2S_START_ADDRESS, 0x18000000+offset); // Write source address
//     dma_set<int>(dma2, MM2S_START_ADDRESS, 0x1a000000+offset); // Write source address
//     dma_set<int>(dma3, MM2S_START_ADDRESS, 0x1c000000+offset); // Write source address
// }

// template <typename Integer>
// int dma_change_end(unsigned int* dma0, unsigned int* dma1, unsigned int* dma2, unsigned int* dma3,int offset) {
//     dma_set<int>(dma0, S2MM_DESTINATION_ADDRESS, 0x16400000+offset); // Write destination address
//     dma_set<int>(dma1, S2MM_DESTINATION_ADDRESS, 0x18400000+offset); // Write destination address
//     dma_set<int>(dma2, S2MM_DESTINATION_ADDRESS, 0x1a400000+offset); // Write destination address
//     dma_set<int>(dma3, S2MM_DESTINATION_ADDRESS, 0x1c400000+offset); // Write destination address
// }


int check(int check) {
    std::cout << "Check" << std::endl;
}


#endif
