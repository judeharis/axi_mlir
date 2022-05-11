#ifndef BENCHCONFIG_H
#define BENCHCONFIG_H

#define R 2

#define tile_M 16
#define tile_N 16
#define tile_K 16
#define M 64
#define N 64
#define K 64

// Modify values of MNK based on the target call
// #define MLIRMATMULCALL matmul_m64_n64_k64_L1_call
// #define CIMLIRMATMULCALL _mlir_ciface_matmul_m64_n64_k64_L1_call

// #define MLIRMATMULCALL matmul_m64_n64_k64_MEM_call
// #define CIMLIRMATMULCALL _mlir_ciface_matmul_m64_n64_k64_MEM_call

// For ACCEL RUN with only ACCEL tile
// Call must match the tile sizes defined for M,N,K
// #define MLIRMATMULCALL matmul_m32_n32_k32_L1_call
// #define CIMLIRMATMULCALL _mlir_ciface_matmul_m32_n32_k32_L1_call

// For CPU RUN - no accelerator or DMA calls at all
// Call must match the 
// #define MLIRMATMULCALL matmul_m32_n32_k32_CPU_call
// #define CIMLIRMATMULCALL _mlir_ciface_matmul_m32_n32_k32_CPU_call

#define MLIRMATMULCALL matmul_m64_n64_k64_MEM_call
#define CIMLIRMATMULCALL _mlir_ciface_matmul_m64_n64_k64_MEM_call

#define MLIRMATMULCALLCPU matmul_m64_n64_k64_CPU_call
#define CIMLIRMATMULCALLCPU _mlir_ciface_matmul_m64_n64_k64_CPU_call

#endif /* BENCHCONFIG_H */