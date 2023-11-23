#ifndef MLIRUTILS_H
#define MLIRUTILS_H

// 2D Memref of type int
typedef struct {
  int *allocated;
  int *aligned;
  int64_t offset;
  int64_t size[2];
  int64_t stride[2];
} memref_2d_descriptor;

// Unranked MemRef
typedef struct {
  int64_t rank;
  void *descriptor;
} UnrankedMemRefType;

// Print with C interface
extern "C" void _mlir_ciface_print_memref_i32(UnrankedMemRefType *arg0);

// Print with raw call
extern "C" void print_memref_i32(int64_t rank, void *ptr);

// This file is automatically generated
#include "mlir_matmuls.h.inc"

#endif /* MLIRUTILS_H */