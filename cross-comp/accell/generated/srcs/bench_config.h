#ifndef BENCHCONFIG_H
#define BENCHCONFIG_H

#define R 2

#define tile_M 4
#define tile_N 4
#define tile_K 4
#define M 8
#define N 8
#define K 8


// Modify values of MNK based on the target call
#define MLIRMATMULCALL matmul_m8_n8_k8_L1_call
#define CIMLIRMATMULCALL _mlir_ciface_matmul_m8_n8_k8_L1_call

#endif /* BENCHCONFIG_H */