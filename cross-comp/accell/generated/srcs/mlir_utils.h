#ifndef GRANDPARENT_H
#define GRANDPARENT_H

#include <mlir_matmuls.h>


// 2D Memref of type int
typedef struct
{
  int *allocated;
  int *aligned;
  int64_t offset;
  int64_t size[2];
  int64_t stride[2];
} memref_2d_descriptor;

// Unranked MemRef
typedef struct
{
  int64_t rank;
  void *descriptor;
} UnrankedMemRefType;


// Print with C interface
void _mlir_ciface_print_memref_i32(UnrankedMemRefType *arg0);

// Print with raw call
void print_memref_i32(int64_t rank, void *ptr);

#endif /* GRANDPARENT_H */