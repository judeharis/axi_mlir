#ifndef MM_MAN_v4_AS_H
#define MM_MAN_v4_AS_H

#include "mlir/ExecutionEngine/axi/api_v1.h"

#include "../bench_config.h"

#define A_buffer 4096
#define B_buffer 4096
#define C_buffer 4096

void v4_As(int *A, volatile int *B, int *C) {
#if DBG
  printf("==============================\n");
  printf("ACC on file: %s\n", __FILE__);
  printf("=-----------------------=\n");
#endif

  // Init DMA + ACC
#ifdef SYSC_T
  int i = 0;
  for (int k = 0; k < K; k += 1) {
    for (int n = 0; n < N; n += 1)
      B[i++] += (-1) + 1;
  }
  struct dma dma1;
  dma1.dma_init(0, 0, 10000, 0, 10000);

#else
  struct dma dma1;
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
#endif

#ifndef block_M
  // Block M: tiling factor for dim M, after taking to account size of B and C
  // buffers, Block K and N, and compute tile size for K
  int block_M = std::min(C_buffer / tile_N, std::min(A_buffer / tile_K, M));
#endif

#ifndef block_N
  // Block N: tiling factor for dim N, after taking into account the size of A
  // and C buffers, and compute tile size for M and K
  int block_N = std::min(C_buffer / block_M, std::min(B_buffer / tile_K, N));
#endif

#ifndef block_K
  // Block K: tiling factor for dim K, after taking into account: size of A and
  // B buffers, and compute tile size for N and M
  int block_K = std::min(B_buffer / block_M, std::min(A_buffer / block_N, K));
#endif

  // Start Tiling
  for (int m = 0; m < M; m += block_M) {
    for (int k = 0; k < K; k += block_K) {
      // Gets pointer to DMA_IN_BUFFER
      unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();

      // Data_len is used to track what is in the DMA_IN_BUFFER
      int data_len = 0;

      // Encodes HEADER; Tells accelerator to expect A, B tiles and compute C
      uint32_t op_code = 1;
      uint32_t ce_a = 0;
      ce_a += block_K;
      ce_a = ce_a << 10;
      ce_a += block_N;
      ce_a = ce_a << 10;
      ce_a += block_M;

      dma_inbuffer[data_len++] = op_code;
      dma_inbuffer[data_len++] = ce_a;

      // Copies A into DMA_IN_BUFFER; Increments data_len by length of A
      for (int tm = 0; tm < block_M; tm++)
        for (int tk = 0; tk < block_K; tk++)
          dma_inbuffer[data_len + block_K * tm + tk] =
              A[(m + tm) * K + (k + tk)];
      data_len += block_M * block_K;

      // Sends data_len of data
      dma1.dma_start_send(data_len, 0);
      dma1.dma_wait_send();

      for (int n = 0; n < N; n += block_N) {

        data_len = 0;
        // Encodes HEADER; Tells accelerator to expect send C
        uint32_t op_code = 14;
        uint32_t ce_a = 0;
        ce_a += block_K;
        ce_a = ce_a << 10;
        ce_a += block_N;
        ce_a = ce_a << 10;
        ce_a += block_M;

        dma_inbuffer[data_len++] = op_code;
        dma_inbuffer[data_len++] = ce_a;

        // Copies B into DMA_IN_BUFFER; Increments data_len by length of B
        for (int tk = 0; tk < block_K; tk++)
          for (int tn = 0; tn < block_N; tn++)
            dma_inbuffer[data_len + block_N * tk + tn] =
                B[(k + tk) * N + (n + tn)];
        data_len += block_K * block_N;

        dma1.dma_start_send(data_len, 0);
        dma1.dma_wait_send();

        // Indicates to DMA, how much space is available and where it is
        dma1.dma_start_recv(block_M * block_N, 0);
        dma1.dma_wait_recv();

        // Gets pointer to DMA_OUT_BUFFER
        unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();

        // Copies result from DMA_OUT_BUFFER to padded output buffer
        for (int tm = 0; tm < block_M; tm++) {
          for (int tn = 0; tn < block_N; tn++) {
            C[(m + tm) * N + n + tn] += dma_outbuffer[block_N * tm + tn];
          }
        }
      }
    }
  }
  dma1.dma_free();
}

#endif /* MM_MAN_v4_AS_H */