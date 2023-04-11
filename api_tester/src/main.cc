#include "mlir/ExecutionEngine/axi/api_v1.h"
#include "mm_helper.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>

using namespace std;
int main(int argc, char *argv[]) {
#define cols 4
#define rows 4
#define depth 4

  int inputs[rows * depth];
  int weights[depth * cols];
  int weightsT[depth * cols];
  int outputs[cols * rows];
  int acc_outputs[cols * rows];

  for (int i = 0; i < cols * rows; i++) {
    outputs[i] = 0;
    acc_outputs[i] = 0;
  }

  for (int i = 0; i < rows * depth; i++)
    inputs[i] = 1;
  for (int i = 0; i < depth * cols; i++)
    weights[i] = i + 1;
  for (int i = 0; i < depth; ++i)
    for (int j = 0; j < cols; ++j)
      weightsT[i * cols + j] = weights[j * depth + i];

  vector<int> A(inputs, inputs + sizeof(inputs) / sizeof(inputs[0]));
  vector<int> B(weights, weights + sizeof(weights) / sizeof(weights[0]));
  vector<int> C(outputs, outputs + sizeof(outputs) / sizeof(outputs[0]));

  cout << "Input Matix" << endl;
  print_matrix(rows, depth, A);
  cout << "Weight Matix" << endl;
  print_matrix(depth, cols, B);

  simpleMM(rows, cols, depth, A, B, C);
  cout << "Correct Results" << endl;
  print_matrix(rows, cols, C);

  struct dma dma1;

#ifndef REAL
  dma1.dma_init(0, 0, 1000, 0, 1000);
  dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int *>(inputs),
                            rows * depth, 0);
  dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int *>(weightsT),
                            depth * cols, rows * depth);
  dma1.dma_start_send(16, 0);
  dma1.dma_wait_send();
  dma1.dma_start_send(16, 16);
  dma1.dma_wait_send();
  dma1.dma_start_recv(rows * cols, 0);
  dma1.dma_wait_recv();
  dma1.dma_copy_from_outbuffer(reinterpret_cast<unsigned int *>(acc_outputs),
                               cols * rows, 0);
  dma1.dma_free();
#else
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
  dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int *>(inputs),
                            rows * depth, dma1.current_input_offset);
  dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int *>(weightsT),
                            depth * cols, dma1.current_input_offset);
  dma1.dma_start_send(dma1.current_input_offset, 0);
  dma1.dma_start_recv(rows * cols, 0);
  dma1.dma_wait_send();
  dma1.dma_wait_recv();
  dma1.dma_copy_from_outbuffer(reinterpret_cast<unsigned int *>(acc_outputs),
                               cols * rows, 0);
#endif

  vector<int> acc_C(acc_outputs,
                    acc_outputs + sizeof(acc_outputs) / sizeof(acc_outputs[0]));
  cout << "Accelerated Results" << endl;
  print_matrix(rows, cols, acc_C);
}