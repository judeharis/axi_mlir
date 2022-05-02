// Compile the MLIR file to LLVM:
// RUN: mlir-opt %t/input.mlir \
// RUN:  -test-linalg-to-axi4mlir="flow-cpu-accumulation
// tile-sizes=128,128,128,32,32,32" \
// RUN:  -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting
// --buffer-deallocation \
// RUN:  -convert-scf-to-cf  \
// RUN:  -arith-expand \
// RUN:  -memref-expand \
// RUN:  -convert-vector-to-llvm \
// RUN:  -convert-memref-to-llvm="index-bitwidth=$BITW" \
// RUN:  -convert-arith-to-llvm="index-bitwidth=$BITW" \
// RUN:  -convert-std-to-llvm="index-bitwidth=$BITW" \
// RUN:  -reconcile-unrealized-casts \
// RUN: | mlir-translate --mlir-to-llvmir -o %t.ll

// These instructions are not 100% correct. Please use compile.sh file.
// Generate an object file for the MLIR code
// RUN: llc %t.ll -o %t.o -filetype=obj

// Compile the current C file and link it to the MLIR code:
// RUN: %host_cc %s %t.o -o %t.exe

// Exec
// RUN: %t.exe | FileCheck %s

// #include <stdint.h>
// #include <stdio.h>

#include <cstdint>
#include <iostream>

#include "mlir_utils.h"
#include "mm4x4v1_ts1.h"



// Define the API for the MLIR function, see
// https://mlir.llvm.org/docs/TargetLLVMIR/#calling-conventions for details.
//
// The function takes 3 2D memref, the signature in MLIR LLVM dialect will be:
// llvm.func @matmul_m8_n8_k8_L1_call(
//   // First Memref (%arg0)
//      %allocated_ptr0: !llvm.ptr<int>, %aligned_ptr0: !llvm.ptr<int>,
//      %offset0: i64, %size0_d0: i64, %size0_d1: i64, %stride0_d0: i64,
//      %stride0_d1: i64,
//   // Second Memref (%arg1)
//      %allocated_ptr1: !llvm.ptr<int>, %aligned_ptr1: !llvm.ptr<int>,
//      %offset1: i64, %size1_d0: i64, %size1_d1: i64, %stride1_d0: i64,
//      %stride1_d1: i64,
//   // Third Memref (%arg2)
//      %allocated_ptr2: !llvm.ptr<int>, %aligned_ptr2: !llvm.ptr<int>,
//      %offset2: i64, %size2_d0: i64, %size2_d1: i64, %stride2_d0: i64,
//      %stride2_d1: i64,
//
// void matmul_m8_n8_k8_L1_call(
//     int *allocated_ptr0, int *aligned_ptr0,
//     int64_t offset0, int64_t size0_d0, int64_t size0_d1,
//     int64_t stride0_d0, int64_t stride0_d1,
//     // Second Memref (%arg1)
//     int *allocated_ptr1, int *aligned_ptr1,
//     int64_t offset1, int64_t size1_d0, int64_t size1_d1,
//     int64_t stride1_d0, int64_t stride1_d1,
//     int *allocated_ptr2, int *aligned_ptr2,
//     int64_t offset2, int64_t size2_d0, int64_t size2_d1,
//     int64_t stride2_d0, int64_t stride2_d1);

// The llvm.emit_c_interface will also trigger emission of another wrapper:
// llvm.func @_mlir_ciface_matmul_m8_n8_k8_L1_call(
//   %arg0: !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64,
//                            array<2 x i64>, array<2 x i64>)>>,
//   %arg1: !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64,
//                            array<2 x i64>, array<2 x i64>)>>,
//   %arg2: !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64,
//                            array<2 x i64>, array<2 x i64>)>>)
// -> void

// Rank
#define R 2

#define tile_M 4
#define tile_N 4
#define tile_K 4

#define M 8
#define N 8
#define K 8
int arg0[M][K];
int arg1[K][N];
int arg2[M][N];

void dump() {
  for (int i = 0; i < N; i++) {
    printf("[");
    for (int j = 0; j < M; j++)
      printf("%d,\t", (int)arg0[i][j]);
    printf("] [");
    for (int j = 0; j < M; j++)
      printf("%d,\t", (int)arg1[i][j]);
    printf("] [");
    for (int j = 0; j < M; j++)
      printf("%d,\t", (int)arg2[i][j]);
    printf("]\n");
  }
}


int main() {

  memref_2d_descriptor arg0_descriptor = {(int *)arg0, (int *)arg0, 0, M, K, K, 1};
  memref_2d_descriptor arg1_descriptor = {(int *)arg1, (int *)arg1, 0, K, N, N, 1};
  memref_2d_descriptor arg2_descriptor = {(int *)arg2, (int *)arg2, 0, M, N, N, 1};

  // ==========================================================
  // C++ Version
  // Reset
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      arg0[i][j] = 1;
      arg1[i][j] = 1;
      arg2[i][j] = 0;
    }
  }

  printf("Call into C++\n");
  v1_ts1(arg0, arg1, arg2);
  printf("After C++:\n");
  dump();

  // ==========================================================
  // MLIR without C interface
  // Reset
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      arg0[i][j] = 1;
      arg1[i][j] = 1;
      arg2[i][j] = 0;
    }
  }

  printf("Call into MLIR\n");
  matmul_m8_n8_k8_L1_call((int *)arg0, (int *)arg0, 0, M, K, K, 1,
                 (int *)arg1, (int *)arg1, 0, K, N, N, 1,
                 (int *)arg2, (int *)arg2, 0, M, N, N, 1);
  printf("After MLIR without C interface:\n");
  dump();
  
  print_memref_i32(R, &arg0_descriptor);
  print_memref_i32(R, &arg1_descriptor);
  print_memref_i32(R, &arg2_descriptor);
  
  // ==========================================================
  // MLIR with C interface
  // Reset
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      arg0[i][j] = 1;
      arg1[i][j] = 1;
      arg2[i][j] = 0;
    }
  }

  printf("Call into MLIR\n");
  matmul_m8_n8_k8_L1_call((int *)arg0, (int *)arg0, 0, M, K, K, 0,
                          //
                          (int *)arg1, (int *)arg1, 0, K, N, N, 0,
                          //
                          (int *)arg2, (int *)arg2, 0, M, N, N, 0);

  _mlir_ciface_matmul_m8_n8_k8_L1_call(&arg0_descriptor, &arg1_descriptor, &arg2_descriptor);
  
  printf("After MLIR with C interface:\n");
  dump();

  // Other MLIR prints :
  print_memref_i32(R, &arg0_descriptor);
  print_memref_i32(R, &arg1_descriptor);
  print_memref_i32(R, &arg2_descriptor);

  return 0;
}
