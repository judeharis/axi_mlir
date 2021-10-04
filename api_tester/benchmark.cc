#include "mlir/ExecutionEngine/axi/api_v1.h"
#include "mm_helper.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>

// #ifdef ACC_PROFILE
// #define prf_start(N) auto start##N = chrono::steady_clock::now();
// #define prf_end(N,X) auto end##N = chrono::steady_clock::now(); X +=
// end##N-start##N; #else #define prf_start(N) #define prf_end(N,X) #endif

#include <chrono>
#define prf_start(N) auto start##N = chrono::steady_clock::now();
#define prf_end(N, X)                                                          \
  auto end##N = chrono::steady_clock::now();                                   \
  X += end##N - start##N;

using namespace std;
int main(int argc, char *argv[]) {
#define cols 4
#define rows 4
#define depth 4

  int inputs[rows * depth];
  int weights[depth * cols];
  int weightsT[depth * cols];
  int outputs[cols * rows];
  int accelerated_outputs[(cols * rows + 1) * 10000];

  for (int i = 0; i < cols * rows; i++) {
    outputs[i] = 0;
    accelerated_outputs[i] = 0;
  }

  for (int i = 0; i < rows * depth; i++)
    inputs[i] = 1;
  for (int i = 0; i < depth * cols; i++)
    weights[i] = i + 1;
  for (int i = 0; i < depth; ++i)
    for (int j = 0; j < cols; ++j)
      weightsT[i * cols + j] = weights[j * depth + i];

  cout << "Input Matix" << endl;
  print_matrix(rows, depth, inputs);
  cout << "Weight Matix" << endl;
  print_matrix(depth, cols, weights);

  simpleMM(rows, cols, depth, inputs, weights, outputs);
  cout << "Correct Results" << endl;
  print_matrix(rows, cols, outputs);

  struct dma dma1;
  std::chrono::duration<double, std::milli> duration;
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);

  prf_start(1);
  for (int i = 0; i < 1000; i++) {
    dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int *>(inputs),
                              rows * depth, dma1.current_input_offset);
    dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int *>(weightsT),
                              depth * cols, dma1.current_input_offset);
    dma1.dma_start_send(dma1.current_input_offset, 0);
    dma1.dma_start_recv(rows * cols + 1, i * 16);
    dma1.dma_wait_send();
    dma1.dma_wait_recv();
    dma1.dma_copy_from_outbuffer(
        reinterpret_cast<unsigned int *>(accelerated_outputs + i * 16),
        cols * rows, i * 16);
  }
  prf_end(1, duration);
  double fduration =
      std::chrono::duration<double, std::milli>(duration).count();
  cout << "Duration : " << fduration << " ms" << endl;

  std::ofstream outfile;
  outfile.open("out.txt");
  outfile << "";
  outfile.close();
  for (int i = 0; i < 10; i++)
    save_matrix("out.txt", rows, cols, accelerated_outputs + i * 16);

  cout << "Accelerated Results" << endl;
  print_matrix(rows, cols, accelerated_outputs);
}
