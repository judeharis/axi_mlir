#ifndef CONV_CONFIG_H
#define CONV_CONFIG_H

// #define R 2

// Accelerator size
// #ifndef tile_M
// #define tile_M 16
// #endif

// #ifndef tile_N
// #define tile_N 16
// #endif

// #ifndef tile_K
// #define tile_K 16
// #endif

// Problem Size
#ifndef B
#define B 1
#endif

#ifndef IHW
#define IHW 9
#endif

#ifndef IC
#define IC 8
#endif

#ifndef FHW
#define FHW 5
#endif

#ifndef OC
#define OC 2
#endif

#ifndef ST
#define ST 1
#endif

// Calls
// #ifndef MLIRMATMULCALL
// #define MLIRMATMULCALL matmul_m64_n64_k64_MEM_call
// #endif
// #ifndef CIMLIRMATMULCALL
// #define CIMLIRMATMULCALL _mlir_ciface_matmul_m64_n64_k64_MEM_call
// #endif

// #ifndef MLIRMATMULCALLCPU
// #define MLIRMATMULCALLCPU matmul_m64_n64_k64_CPU_call
// #endif

// #ifndef CIMLIRMATMULCALLCPU
// #define CIMLIRMATMULCALLCPU _mlir_ciface_matmul_m64_n64_k64_CPU_call
// #endif

#endif /* CONV_CONFIG_H */