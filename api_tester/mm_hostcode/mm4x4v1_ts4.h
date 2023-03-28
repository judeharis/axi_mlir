#ifndef MM4x4v1_TS4_H
#define MM4x4v1_TS4_H

#include "mlir/ExecutionEngine/axi/api_v1.h"

#include "bench_config.h"

void v1_ts4(int *A, int *B, int *C) {
  //   LOG("=========================");
  //   LOG("ACC: MM_4x4v1");
  //   LOG("Tiling Strat: 2");
  //   LOG("=========================");

  // Init DMA + ACC
  struct dma dma1;

  // dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);

  // int in_buffer_req_size = K * (M + N) * 4;
  // std::cout << in_buffer_req_size << std::endl;
  // in_buffer_req_size =
  //     roundUp(in_buffer_req_size + getpagesize(), getpagesize());
  // std::cout << in_buffer_req_size << std::endl;
  // dma1.dma_init(0x40400000, 0x16000000, in_buffer_req_size, 0x16400000,
  // 65536); std::cout << in_buffer_req_size << std::endl;

  dma1.dma_init(0x40400000, 0x16000000, 4194304, 0x16400000, 4194304);

  unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
  int dma_in_i = 0;
  int M_tile_size = tile_M * tile_K;
  int N_tile_size = tile_N * tile_K;

  int max_A_tiles = K/tile_K * M/tile_M;
  int A_tiles_offsets[max_A_tiles];
  int A_tile_count=0;

  for (int k = 0; k < K; k += tile_K) {
    for (int m = 0; m < M; m += tile_M) {
      for (int tm = 0; tm < tile_M; tm++)
        for (int tk = 0; tk < tile_K; tk++)
          dma_inbuffer[dma_in_i + tile_K * tm + tk] =
              A[(m + tm) * K + (k + tk)];

      A_tiles_offsets[A_tile_count++] = dma_in_i;
      dma_in_i += M_tile_size;
    }
  }
  int max_B_tiles = K/tile_K * N/tile_N;
  int B_tiles_offsets[max_B_tiles];
  int B_tile_count=0;

  for (int k = 0; k < K; k += tile_K) {
    for (int n = 0; n < N; n += tile_N) {
      for (int tn = 0; tn < tile_N; tn++)
        for (int tk = 0; tk < tile_K; tk++)
          dma_inbuffer[dma_in_i + tile_K * tn + tk] =
              B[(k + tk) * N + (n + tn)];

      B_tiles_offsets[B_tile_count++] = dma_in_i;
      dma_in_i += N_tile_size;
    }
  }


  B_tile_count=0;
  A_tile_count=0;

  // Start Tiling
  for (int k = 0; k < K; k += tile_K) {
    for (int n = 0; n < N; n += tile_N) {

      int B_tile_offset = B_tiles_offsets[B_tile_count++];
      for (int m = 0; m < M; m += tile_M) {

        // Sends data_len of data
        int A_tile_offset = A_tiles_offsets[A_tile_count++];
        
        dma1.dma_start_send(tile_M * tile_K, A_tile_offset);
        dma1.dma_wait_send();

        dma1.dma_start_send(tile_N * tile_K, B_tile_offset);
        dma1.dma_wait_send();


        dma1.dma_start_recv(tile_N * tile_M, 0);
        dma1.dma_wait_recv();

        unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();
        for (int tn = 0; tn < tile_N; tn++) {
          for (int tm = 0; tm < tile_M; tm++) {
            C[(m + tm) * N + (n + tn)] += dma_outbuffer[tile_M * tn + tm];
          }
        }
      }
      A_tile_count=0;
    }
  }
  dma1.dma_free();
}

#endif /* MM4x4v1_TS4_H */