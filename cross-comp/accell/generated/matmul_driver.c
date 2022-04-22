// Compile the MLIR file to LLVM:
// RUN: mlir-opt %t/input.mlir \
// RUN:  -lower-affine  -convert-scf-to-cf  -convert-memref-to-llvm \
// RUN:  -convert-std-to-llvm -reconcile-unrealized-casts \
// RUN: | mlir-translate --mlir-to-llvmir -o %t.ll

// Generate an object file for the MLIR code
// RUN: llc %t.ll -o %t.o -filetype=obj

// Compile the current C file and link it to the MLIR code:
// RUN: %host_cc %s %t.o -o %t.exe

// Exec
// RUN: %t.exe | FileCheck %s

#include <stdint.h>
#include <stdio.h>

// Define the API for the MLIR function, see
// https://mlir.llvm.org/docs/TargetLLVMIR/#calling-conventions for details.
//
// The function takes 3 2D memref, the signature in MLIR LLVM dialect will be:
// llvm.func @matmul_m4_n4_k4_L1_call(
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
void matmul_m4_n4_k4_L1_call(
    int *allocated_ptr0, int *aligned_ptr0,
    intptr_t offset0, intptr_t size0_d0, intptr_t size0_d1,
    intptr_t stride0_d0, intptr_t stride0_d1,
    // Second Memref (%arg1)
    int *allocated_ptr1, int *aligned_ptr1,
    intptr_t offset1, intptr_t size1_d0, intptr_t size1_d1,
    intptr_t stride1_d0, intptr_t stride1_d1,
    int *allocated_ptr2, int *aligned_ptr2,
    intptr_t offset2, intptr_t size2_d0, intptr_t size2_d1,
    intptr_t stride2_d0, intptr_t stride2_d1);

// The llvm.emit_c_interface will also trigger emission of another wrapper:
// llvm.func @_mlir_ciface_matmul_m4_n4_k4_L1_call(
//   %arg0: !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64,
//                            array<2 x i64>, array<2 x i64>)>>,
//   %arg1: !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64,
//                            array<2 x i64>, array<2 x i64>)>>,
//   %arg2: !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64,
//                            array<2 x i64>, array<2 x i64>)>>)
// -> void
typedef struct
{
  int *allocated;
  int *aligned;
  intptr_t offset;
  intptr_t size[2];
  intptr_t stride[2];
} memref_2d_descriptor;
long long _mlir_ciface_add_memref(memref_2d_descriptor *arg0,
                                  memref_2d_descriptor *arg1);

#define M 4
#define N 4
#define K 4
int arg0[M][K];
int arg1[K][N];
int arg2[M][N];

void dump()
{
  for (int i = 0; i < M; i++)
  {
    printf("[");
    for (int j = 0; j < K; j++)
      printf("%d,\t", (int)arg0[i][j]);
    printf("] [");
  }

  for (int i = 0; i < K; i++)
  {
    printf("[");
    for (int j = 0; j < N; j++)
      printf("%d,\t", (int)arg1[i][j]);
    printf("]\n");
  }

  for (int i = 0; i < M; i++)
  {
    printf("[");
    for (int j = 0; j < N; j++)
      printf("%d,\t", (int)arg2[i][j]);
    printf("]\n");
  }
}

int main()
{
  int count = 0;
  // TODO Fix these bounds for different sizes
  for (int i = 0; i < M; i++)
  {
    for (int j = 0; j < N; j++)
    {
      arg0[i][j] = count++;
      arg1[i][j] = count++;
      arg2[i][j] = count++;
    }
  }
  printf("Before:\n");
  dump();

  // Call into MLIR.
  matmul_m4_n4_k4_L1_call(
      (int *)arg0, (int *)arg0, 0, M, K, K, 0,
      //
      (int *)arg1, (int *)arg1, 0, K, N, N, 0,
      //
      (int *)arg2, (int *)arg2, 0, M, N, N, 0);

  printf("Result: C[0,0]=%d\n", arg2[0][0]);

  printf("After:\n");
  dump();

  // Reset the input and re-apply the same function use the C API wrapper.
  count = 0;
  for (int i = 0; i < N; i++)
  {
    for (int j = 0; j < M; j++)
    {
      arg0[i][j] = count++;
      arg1[i][j] = count++;
      arg2[i][j] = count++;
    }
  }

  // Call into MLIR.
  memref_2d_descriptor arg0_descriptor = {
      (int *)arg0, (int *)arg0, 0, M, K, K, 0};
  memref_2d_descriptor arg1_descriptor = {
      (int *)arg1, (int *)arg1, 0, K, N, N, 0};
  memref_2d_descriptor arg2_descriptor = {
      (int *)arg2, (int *)arg2, 0, M, N, N, 0};

  _mlir_ciface_matmul_m4_n4_k4_L1_call(&arg0_descriptor, &arg1_descriptor, &arg2_descriptor);

  printf("Result: C[0,0]=%d\n", arg2[0][0]);

  printf("After2:\n");
  dump();

  return 0;
}
