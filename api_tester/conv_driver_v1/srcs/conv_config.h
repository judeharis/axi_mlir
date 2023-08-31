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
#define IHW 230
#endif

#ifndef IC
#define IC 8
#endif

#ifndef FHW
#define FHW 7
#endif

#ifndef OC
#define OC 64
#endif

#ifndef ST
#define ST 2
#endif

// Calls
#ifndef MLIRCONV2DCALL
#define MLIRCONV2DCALL conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_ACC_v3_Fs_call
#endif
#ifndef CIMLIRCONV2DCALL
#define CIMLIRCONV2DCALL _mlir_ciface_conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_ACC_v3_Fs_call
#endif

#ifndef MLIRCONV2DCALLCPU
#define MLIRCONV2DCALLCPU conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_CPU_call
#endif

#ifndef CIMLIRCONV2DCALLCPU
#define CIMLIRCONV2DCALLCPU _mlir_ciface_conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_CPU_call
#endif

#endif /* CONV_CONFIG_H */