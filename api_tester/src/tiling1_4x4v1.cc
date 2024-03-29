#include "mlir/ExecutionEngine/axi/api_v1.h"
#include "mm_helper.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <vector>

#define tile_N 4
#define tile_M 4
#define tile_K 4
using namespace std;
int main(int argc, char *argv[]) {

  LOG("=========================");
  LOG("ACC: MM_4x4v1");
  LOG("Tiling Strat: 1");
  LOG("=========================");

  // Determine dimensions for padding to correct tile_size
  int pN = roundup(N, tile_N);
  int pM = roundup(M, tile_M);
  int pK = roundup(K, tile_K);

  // Define A, B and C
  std::vector<int> A(M * K);
  std::vector<int> B(K * N);
  std::vector<int> C(M * N);

  // Creates padded matrices
  std::vector<int> padded_A(pM * pK, 0);
  std::vector<int> padded_BT(pK * pN, 0);
  std::vector<int> padded_C(pN * pM, 0);

  // Set C to 0; Fills A & B with data
  // for (int i = 0; i < M * N; i++)
  //   C[i] = 0;
  // for (int i = 0; i < N * K; i++)
  //   B[i] = 1;
  // for (int i = 0; i < K * M; i++)
  //   A[i] = 2;

  for (int i = 0; i < M; i++) {
    for (int j = 0; j < K; j++) {
      A[i * K + j] = i;
    }
  }
  for (int i = 0; i < K; i++) {
    for (int j = 0; j < N; j++) {
      B[i * N + j] = j;
    }
  }
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      C[i * N + j] = 0;
    }
  }
  for (int i = 0; i < pN * pM; i++)
    padded_C[i] = 0;

  // Transfers Data to padded matrices
  pad_matrix(N, K, tile_N, tile_K, A, padded_A);
  pad_matrix(K, M, tile_K, tile_M, B, padded_BT);

#if CPU_MM
  // C++ MM implementation
  simpleMM(N, M, K, A, B, C);
#endif

  // Init DMA + ACC
  struct dma dma1;
#ifndef REAL
  dma1.dma_init(0, 0, 1000, 0, 1000);
#else
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
#endif

  // Start Tiling
  for (int k = 0; k < pK; k += tile_K) {
    for (int n = 0; n < pN; n += tile_N) {
      for (int m = 0; m < pM; m += tile_M) {

        // C stationary
        int A_base = m * pK + k;
        int B_base = k * pN + n;
        int C_base = m * pN + n;

        // (K * tn) +  (k * N) + n + tk;

        // tn + tm* pN + m * pN + n

        // Gets pointer to DMA_IN_BUFFER
        unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();

        // Data_len is used to track what is in the DMA_IN_BUFFER
        int data_len = 0;

        // Copies A into DMA_IN_BUFFER; Increments data_len by length of A
        for (int tm = 0; tm < tile_M; tm++)
          for (int tk = 0; tk < tile_K; tk++)
            dma_inbuffer[data_len + tile_K * tm + tk] =
                padded_A[pK * tm + tk + A_base];
        data_len += tile_N * tile_K;

        // Copies B into DMA_IN_BUFFER; Increments data_len by length of B

        for (int tn = 0; tn < tile_N; tn++)
          for (int tk = 0; tk < tile_K; tk++)
            dma_inbuffer[data_len + tile_K * tn + tk] =
                padded_BT[pK * tn + tk + B_base];
        data_len += tile_M * tile_K;

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
            padded_C[tn + tm * pN + C_base] += dma_outbuffer[tile_N * tm + tn];
            // cout << (tn + tm * pN + C_base) << endl;
            // cout << (pM * tn + tm + C_base) << endl;
          }
        }
      }
    }
  }
  dma1.dma_free();
  // PLOG("=========================");
  // PLOG("ACC: MM_4x4v1");
  // PLOG("Tiling Strat: 1");
  // PLOG("N: " << N << " M: " << M << " K: " << K);
  // PLOG("=========================");

  // Copies padded_C back to C
  std::vector<int> accelerated_C(N * M);
  unpad_matrix(N, M, tile_N, tile_M, padded_C, accelerated_C);

#if CPU_MM
  cout << "=========================" << endl;
  print_matrix(N, M, C, "Correct Results");
  print_matrix(N, M, accelerated_C, "Accelerated Results");
  compare_matrix(N, M, C, accelerated_C);
#endif
}