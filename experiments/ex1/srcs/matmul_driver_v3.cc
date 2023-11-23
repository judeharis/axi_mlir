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

#include "bench_config.h"
#include "mlir_utils.h"
#include "mm_man_v1_Ns.h"

#include "mm_man_v2_As.h"
#include "mm_man_v2_Bs.h"
#include "mm_man_v2_Ns.h"

#include "mm_man_v3_As.h"
#include "mm_man_v3_Bs.h"
#include "mm_man_v3_Cs.h"
#include "mm_man_v3_Ns.h"

#include "mm_man_v4_Ns.h"

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

void dump(int *arg0, int *arg1, int *arg2) {
  printf("--\narg0:\n");
  for (int i = 0; i < M; i++) {
    printf("[");
    for (int j = 0; j < K; j++)
      printf("%d,\t", (int)arg0[i * K + j]);
    printf("]\n");
  }
  printf("--\narg1:\n");
  for (int i = 0; i < K; i++) {
    printf("[");
    for (int j = 0; j < N; j++)
      printf("%d,\t", (int)arg1[i * N + j]);
    printf("]\n");
  }
  printf("--\narg2:\n");
  for (int i = 0; i < M; i++) {
    printf("[");
    for (int j = 0; j < N; j++)
      printf("%d,\t", (int)arg2[i * N + j]);
    printf("]\n");
  }
}

void reset(int *arg0, int *arg1, int *arg2) {
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < K; j++) {
      arg0[i * K + j] = i;
    }
  }
  for (int i = 0; i < K; i++) {
    for (int j = 0; j < N; j++) {
      arg1[i * N + j] = j;

      // Do the transpose
      // arg1[i * N + j] = i;
    }
  }
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      arg2[i * N + j] = 0;
    }
  }
}

void simpleMM(int *arg0, int *arg1, int *arg2) {
  for (int m = 0; m < M; m++) {
    for (int n = 0; n < N; n++) {
      int acc = 0;
      for (int k = 0; k < K; k++) {
        int x = arg0[m * K + k];
        int y = arg1[k * N + n];
        acc += x * y;
      }
      arg2[m * N + n] = acc;
    }
  }
}

int testCorrect(int *arg1, int *arg2) {
  bool equal = true;
  for (int i = 0; i < N * M; i++) {
    if (arg1[i] != arg2[i]) {
      equal = false;
      break;
    }
  }
  if (!equal)
    std::cout << "  FAILED" << std::endl;
  else
    std::cout << "  PASSED" << std::endl;
  return equal == true ? 0 : -1;
}

int main() {

  // This allocation is allowed if right dim is known at compile time.
  // However, MLIR expects a flattened array, and this is allocating
  // an `int **`, which has additional bytes every row of elements.
  // auto arg0 = new int [M][K];
  // auto arg1 = new int [K][N];
  // auto arg2 = new int [M][N];

  auto arg0 = new int[M * K];
  auto arg1 = new int[K * N];
  auto arg2 = new int[M * N];
  auto arg3 = new int[M * N];

  // printf("Before accelerator\n");
  // dump(arg0, arg1, arg2);

  reset(arg0, arg1, arg3);
#if TEST
  // C++ MM implementation
  simpleMM(arg0, arg1, arg3);
#endif

#ifdef RUNCPP
  // ==========================================================
  // C++ Version
  // Reset
  reset(arg0, arg1, arg2);

#ifdef ACCv1Ns
  v1_Ns(arg0, arg1, arg2);

#elif ACCv2As
  v2_As(arg0, arg1, arg2);
#elif ACCv2Bs
  v2_Bs(arg0, arg1, arg2);
#elif ACCv2Ns
  v2_Ns(arg0, arg1, arg2);

#elif ACCv3As
  v3_As(arg0, arg1, arg2);
#elif ACCv3Bs
  v3_Bs(arg0, arg1, arg2);
#elif ACCv3Cs
  v3_Cs(arg0, arg1, arg2);
#elif ACCv3Ns
  v3_Ns(arg0, arg1, arg2);
#elif ACCv4Ns
  v4_Ns(arg0, arg1, arg2);
#else
  std::cout << "No accelerator version specified" << std::endl;
  exit(1);
#endif
#if DBG
  printf("Executed MANUAL version on accelerator\n");
#endif

#elif RUNMLIR
  // ==========================================================
  // MLIR without C interface
  // Reset
  reset(arg0, arg1, arg2);
  // clang-format off
  MLIRMATMULCALL((int *)arg0, (int *)arg0, 0, M, K, K, 1,
                 (int *)arg1, (int *)arg1, 0, K, N, N, 1,
                 (int *)arg2, (int *)arg2, 0, M, N, N, 1);
// clang-format on
#if DBG
  printf("Executed MLIR version on accelerator\n");
#endif
#else
  // ==========================================================
  // MLIR without C interface
  // Reset
  reset(arg0, arg1, arg2);
  // clang-format off
  MLIRMATMULCALLCPU((int *)arg0, (int *)arg0, 0, M, K, K, 1,
                 (int *)arg1, (int *)arg1, 0, K, N, N, 1,
                 (int *)arg2, (int *)arg2, 0, M, N, N, 1);
// clang-format on
#if DBG
  printf("Executed MLIR version on CPU\n");
#endif
#endif

#if DBG
  printf("Problem ");
  printf("M=%d, N=%d, K=%d, tile_M=%d, tile_N=%d, tile_K=%d ", M, N, K, tile_M,
         tile_N, tile_K);
  printf("finished execution. Printing matrices: \n");
  dump(arg0, arg1, arg2);
  printf("Done.\n");
#endif

  int ret = 0;
#if TEST
  // Compare with C++ MM implementation
  ret = testCorrect(arg2, arg3);
  free(arg3);
#endif

  free(arg0);
  free(arg1);
  free(arg2);
  return ret;
}
