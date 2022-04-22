// Example tiling code which uses MM_4x4v2 accelerator.
// Example takes advantage of B stationary capability of the accelerator to
// reduce the number of times B data is sent to the accelerator.

#include "mlir/ExecutionEngine/axi/api_v1.h" // Requires #define ACC_V2 to use the correct accelerator --- "-DACC_V2"
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
  LOG("ACC: MM_4x4v2");
  LOG("Tiling Strat: 1");
  LOG("=========================");

  // Determine dimensions for padding to correct tile_size
  int pN = roundup(N, tile_N);
  int pM = roundup(M, tile_M);
  int pK = roundup(K, tile_K);

  // Define A, B and C
  std::vector<int> A(N * K);
  std::vector<int> B(K * M);
  std::vector<int> C(N * M);

  // Creates padded matrices
  std::vector<int> padded_A(pN * pK, 0);
  std::vector<int> padded_BT(pM * pK, 0);
  std::vector<int> padded_C(pN * pM, 0);

  // Set C to 0; Fills A & B with data
  for (int i = 0; i < M * N; i++)
    C[i] = 0;
  for (int i = 0; i < N * K; i++)
    A[i] = 1;
  for (int i = 0; i < K * M; i++)
    B[i] = i + 1;
  for (int i = 0; i < pN * pM; i++)
    padded_C[i] = 0;

  // Transfers Data to padded matrices
  pad_matrix(N, K, tile_N, tile_K, A, padded_A);
  padT_matrix(K, M, tile_K, tile_M, B, padded_BT);

#if CPU_MM
  // C++ MM implementation
  simpleMM(N, M, K, A, B, C);
#endif

  // Init DMA + ACC
  struct dma dma1;
#ifndef REAL
  dma1.verbose = false;
  dma1.dma_init(0, 0, 1000, 0, 1000);
#else
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
#endif

  // Start Tiling
  for (int k = 0; k < pK; k += tile_K) {
    for (int m = 0; m < pM; m += tile_M) {
      for (int n = 0; n < pN; n += tile_N) {
        // B stationary
        int A_base = n * pK + k;
        int B_base = m * pK + k;
        int C_base = n * pM + m;

        // Gets pointer to DMA_IN_BUFFER
        unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();

        // Data_len is used to track what is in the DMA_IN_BUFFER
        int data_len = 0;

        // Encodes HEADER; Tells accelerator to expect A, B tiles and compute C
        uint32_t h = 7;
        dma_inbuffer[0] = h;
        data_len++;

        // Copies A into DMA_IN_BUFFER; Increments data_len by length of A
        for (int tn = 0; tn < tile_N; tn++)
          for (int tk = 0; tk < tile_K; tk++)
            dma_inbuffer[data_len + tile_K * tn + tk] =
                padded_A[pK * tn + tk + A_base];
        data_len += tile_N * tile_K;

        // Copies B into DMA_IN_BUFFER; Increments data_len by length of B
        for (int tm = 0; tm < tile_M; tm++)
          for (int tk = 0; tk < tile_K; tk++)
            dma_inbuffer[data_len + tile_K * tm + tk] =
                padded_BT[pK * tm + tk + B_base];
        data_len += tile_M * tile_K;

        // Sends data_len of data
        dma1.dma_start_send(data_len, 0);

        // Waits for data to transfer to finish
        dma1.dma_wait_send();

        // Indicates to DMA, how much space is available and where it is
        dma1.dma_start_recv(tile_N * tile_M, 0);

        // Waits for data to be recieved (including TLAST signal)
        dma1.dma_wait_recv();

        // Gets pointer to DMA_OUT_BUFFER
        unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();

        // Copies result from DMA_OUT_BUFFER to padded output buffer
        for (int tn = 0; tn < tile_N; tn++) {
          for (int tm = 0; tm < tile_M; tm++) {
            padded_C[pM * tn + tm + C_base] += dma_outbuffer[tile_M * tn + tm];
          }
        }
      }
    }
  }
  dma1.dma_free();
  // PLOG("=========================");
  // PLOG("ACC: MM_4x4v2");
  // PLOG("Tiling Strat: 1");
  // PLOG("N: " << N << " M: " << M << " K: " << K);
  // PLOG("=========================");

  // Copies padded_C back to C
  std::vector<int> accelerated_C(N * M);
  unpad_matrix(N, M, tile_N, tile_M, padded_C, accelerated_C);

  // cout << "=========================" << endl;
  // cout << "=========================" << endl;
  // cout << "=========================" << endl;
  // cout << "=========================" << endl;
  // print_matrix(N, M, C, "Correct Results");
  // print_matrix(N, M, accelerated_C, "Accelerated Results");
#if CPU_MM
  compare_matrix(N, M, C, accelerated_C);
#endif
}