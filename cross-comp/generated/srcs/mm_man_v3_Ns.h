#ifndef MM4x4v3_TS1_H
#define MM4x4v3_TS1_H

#include "mlir/ExecutionEngine/axi/api_v1.h"

#include "bench_config.h"

void v3_Ns(int *A, volatile int *B, int *C) {
#if DBG
  printf("=========================");
  printf("ACC: MM_4x4v3");
  printf("Tiling Strat: Ns");
  printf("=========================\n");
#endif

  // Init DMA + ACC

#ifdef SYSC_T
  int i = 0;
  for (int k = 0; k < K; k += 1) {
    for (int n = 0; n < N; n += 1)
      B[i++] += (-1) + 1;
  }
  struct dma dma1;
  dma1.dma_init(0, 0, 1000, 0, 1000);

#else
  struct dma dma1;
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
#endif
  // Start Tiling
  for (int k = 0; k < K; k += tile_K) {
    for (int n = 0; n < N; n += tile_N) {
      for (int m = 0; m < M; m += tile_M) {

        int C_base = m * N + n;
        // Gets pointer to DMA_IN_BUFFER
        unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();

        // Data_len is used to track what is in the DMA_IN_BUFFER
        int data_len = 0;

        // Encodes HEADER; Tells accelerator to expect A, B tiles and compute C
        uint32_t h = 15;
        dma_inbuffer[0] = h;
        data_len++;

        // Copies A into DMA_IN_BUFFER; Increments data_len by length of A
        for (int tm = 0; tm < tile_M; tm++)
          for (int tk = 0; tk < tile_K; tk++)
            dma_inbuffer[data_len + tile_K * tm + tk] =
                A[(m + tm) * K + (k + tk)];
        data_len += tile_M * tile_K;

        // Copies B into DMA_IN_BUFFER; Increments data_len by length of B
        for (int tk = 0; tk < tile_K; tk++)
          for (int tn = 0; tn < tile_N; tn++)
            dma_inbuffer[data_len + tile_K * tn + tk] =
                B[(K * tn) + (k * N) + n + tk];

        data_len += tile_N * tile_K;

        // Sends data_len of data
        dma1.dma_start_send(data_len, 0);

        // Waits for data to transfer to finish
        dma1.dma_wait_send();

        // Indicates to DMA, how much space is available and where it is
        dma1.dma_start_recv(tile_N * tile_M, 0);

        // Waits for data to be received (including TLAST signal)
        dma1.dma_wait_recv();

        // Gets pointer to DMA_OUT_BUFFER
        unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();

        // Copies result from DMA_OUT_BUFFER to padded output buffer
        for (int tm = 0; tm < tile_M; tm++) {
          for (int tn = 0; tn < tile_N; tn++) {
            C[tn + (tm + m) * N + n] += dma_outbuffer[tile_N * tm + tn];
          }
        }
      }
    }
  }
  dma1.dma_free();
}

#endif /* MM4x4v3_TS1_H */