# Usage

## To regenerate the source MLIR file

This step is not necessary if the files  `mlir_matmuls.mlir` `mlir_matmuls.h.inc` already have all needed implementations (permutations of matmul calls).

Inside this folder call:

```bash
./generate_all.py 16 2 9 -t ACC_v1_Ns ACC_v2_Ns ACC_v2_As ACC_v2_Bs --template srcs/template_mlir_matmuls.mlir > srcs/mlir_matmuls.mlir
./generate_all.py 16 2 9 -t ACC_v1_Ns ACC_v2_Ns ACC_v2_As ACC_v2_Bs --template srcs/template_mlir_matmuls.h > srcs/mlir_matmuls.h.inc
```
To generate/regenerate or regenerate the mlir matmuls file.

Use `./generate_all.py -h` for instructions.

## To compile into a shared library

Call:

```
./compile.sh
```

This generates the libraries and header files.
These files are going to be placed in the `output` folder.

MLIR functions can be called from C following this format:

```c
typedef struct
{
  int *allocated;
  int *aligned;
  intptr_t offset;
  intptr_t size[2];
  intptr_t stride[2];
} memref_2d_descriptor;

int arg0[M][K];
int arg1[K][N];
int arg2[M][N];

matmul_m4_n4_k4_L1_call(
    (int *)arg0, (int *)arg0, 0, M, K, K, 0,
    //
    (int *)arg1, (int *)arg1, 0, K, N, N, 0,
    //
    (int *)arg2, (int *)arg2, 0, M, N, N, 0);

// OR

memref_2d_descriptor arg0_descriptor = {
    (int *)arg0, (int *)arg0, 0, M, K, K, 0};
memref_2d_descriptor arg1_descriptor = {
    (int *)arg1, (int *)arg1, 0, K, N, N, 0};
memref_2d_descriptor arg2_descriptor = {
    (int *)arg2, (int *)arg2, 0, M, N, N, 0};

_mlir_ciface_matmul_m4_n4_k4_L1_call(&arg0_descriptor, &arg1_descriptor, &arg2_descriptor);

```