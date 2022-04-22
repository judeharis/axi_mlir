# Usage

## To regenerate the source MLIR file

This step is not necessary if the `mlir_matmuls.mlir` file already has all needed implementations (permutaions of matmul calls).

Inside this folder call:

```
./generate_all.py 4 2 9 -t CPU MEM L2 L1 > mlir_matmul_lib.mlir
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

MLIR functions can be called following this format:

```c
TODO
```