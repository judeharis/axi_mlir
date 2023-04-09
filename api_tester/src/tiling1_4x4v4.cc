// Example tiling code which uses MM_4x4v4 accelerator.

#include "mlir/ExecutionEngine/axi/api_v1.h" // Requires #define ACC_V4 to use the correct accelerator --- "-DACC_V4"
#include "mm_helper.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <vector>

#define tile_N 4
#define tile_M 4
#define tile_K 4

#define A_buffer 4096
#define B_buffer 4096
#define C_buffer 4096

using namespace std;
int main(int argc, char *argv[]) {

  LOG("=========================");
  LOG("ACC: MM_4x4v4");
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
    B[i] = 2;
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
  dma1.dma_init(0, 0, 65536, 0, 65536);
#else
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
#endif

  // Block K: tiling factor for dim K, after taking into account: size of A and
  // B buffers, and compute tile size for N and M
  int block_K = std::min(B_buffer / tile_M, std::min(A_buffer / tile_N, pK));

  // Block N: tiling factor for dim N, after taking into account: the size of A
  // and C buffers, Block K, and compute tile size for M
  int block_N = std::min(C_buffer / tile_M, std::min(A_buffer / block_K, pN));

  // Block M: tiling factor for dim M, after taking to account: size of B and C
  // buffers, Block K, and Block N
  int block_M = std::min(C_buffer / block_N, std::min(B_buffer / block_K, pM));

  // int block_K = std::min(B_buffer, std::min(A_buffer, pK));
  // int block_N = std::min(C_buffer, std::min(A_buffer / block_K, pN));
  // int block_M = std::min(C_buffer / block_N, std::min(B_buffer / block_K,
  // pM));

  for (int n = 0; n < pN; n += block_N) {
    for (int m = 0; m < pM; m += block_M) {
      for (int k = 0; k < pK; k += block_K) {

        // NS stationary
        int A_base = n * pK + k;
        int B_base = m * pK + k;
        int C_base = n * pM + m;

        // Gets pointer to DMA_IN_BUFFER
        unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();

        // Data_len is used to track what is in the DMA_IN_BUFFER
        int data_len = 0;

        // Encodes HEADER; Tells accelerator to expect A, B tiles and compute C
        uint32_t op_code = 15;
        uint32_t ce_a = 0;
        uint32_t ce_b = 0;

        ce_a += block_M;
        ce_a = ce_a << 16;
        ce_a += block_N;

        ce_b += block_K;

        dma_inbuffer[data_len++] = op_code;
        dma_inbuffer[data_len++] = ce_a;
        dma_inbuffer[data_len++] = ce_b;

        // Copies A into DMA_IN_BUFFER; Increments data_len by length of A
        for (int tn = 0; tn < block_N; tn++)
          for (int tk = 0; tk < block_K; tk++)
            dma_inbuffer[data_len + block_K * tn + tk] =
                padded_A[pK * tn + tk + A_base];
        data_len += block_N * block_K;

        // Copies B into DMA_IN_BUFFER; Increments data_len by length of B
        for (int tm = 0; tm < block_M; tm++)
          for (int tk = 0; tk < block_K; tk++)
            dma_inbuffer[data_len + block_K * tm + tk] =
                padded_BT[pK * tm + tk + B_base];
        data_len += block_M * block_K;

        // Sends data_len of data
        dma1.dma_start_send(data_len, 0);

        // Waits for data to transfer to finish
        dma1.dma_wait_send();

        // Indicates to DMA, how much space is available and where it is
        dma1.dma_start_recv(block_N * block_M, 0);

        // Waits for data to be recieved (including TLAST signal)
        dma1.dma_wait_recv();

        // Gets pointer to DMA_OUT_BUFFER
        unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();

        // Copies result from DMA_OUT_BUFFER to padded output buffer
        for (int tn = 0; tn < block_N; tn++) {
          for (int tm = 0; tm < block_M; tm++) {
            padded_C[pM * tn + tm + C_base] += dma_outbuffer[block_M * tn + tm];
          }
        }
      }
    }
  }
  dma1.dma_free();
  // PLOG("=========================");
  // PLOG("ACC: MM_4x4v4");
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