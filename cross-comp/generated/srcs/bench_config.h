#ifndef BENCHCONFIG_H
#define BENCHCONFIG_H

#define R 2

// Accelerator size
#ifndef tile_M
#define tile_M 16
#endif

#ifndef tile_N
#define tile_N 16
#endif

#ifndef tile_K
#define tile_K 16
#endif

// Problem Size
#ifndef M
#define M 64
#endif

#ifndef N
#define N 64
#endif

#ifndef K
#define K 64
#endif


// Calls
#ifndef MLIRMATMULCALL
#define MLIRMATMULCALL matmul_m64_n64_k64_MEM_call
#endif
#ifndef CIMLIRMATMULCALL
#define CIMLIRMATMULCALL _mlir_ciface_matmul_m64_n64_k64_MEM_call
#endif

#ifndef MLIRMATMULCALLCPU
#define MLIRMATMULCALLCPU matmul_m64_n64_k64_CPU_call
#endif

#ifndef CIMLIRMATMULCALLCPU
#define CIMLIRMATMULCALLCPU _mlir_ciface_matmul_m64_n64_k64_CPU_call
#endif

#endif /* BENCHCONFIG_H */