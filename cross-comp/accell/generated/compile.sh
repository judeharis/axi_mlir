#!/bin/bash

set -e -o pipefail
set -x

# This is not the right target
# target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
# target triple = "armv7-none-linux-android"

OUTDIR=output
export PROJ_ROOT=/working_dir
mkdir -p $OUTDIR

BITW=64

# Declare an array of string with type
declare -a StringArray=(
    "mlir_matmuls"
)
 
# Iterate the string array using for loop
for INPUT in ${StringArray[@]}; do

# Adding the emit-c-wrappers options affect every function declared inside the mlir file
#-convert-std-to-llvm="index-bitwidth=$BITW emit-c-wrappers" \

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
    -test-linalg-to-axi4mlir="flow-cpu-accumulation tile-sizes=128,128,128,32,32,32" \
    -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting --buffer-deallocation \
    -convert-scf-to-cf  \
    -arith-expand \
    -memref-expand \
    -convert-vector-to-llvm \
    -convert-memref-to-llvm="index-bitwidth=$BITW" \
    -convert-arith-to-llvm="index-bitwidth=$BITW" \
    -convert-std-to-llvm="index-bitwidth=$BITW" \
    -reconcile-unrealized-casts \
    $INPUT.mlir \
    -o $OUTDIR/llvm.mlir 
    # \
    # -print-ir-before-all 2>&1 | cat > intermediate.mlir

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-translate --mlir-to-llvmir $OUTDIR/llvm.mlir -o $OUTDIR/libmlirmatmuls.ll

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang \
    --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
    -mfpu=neon -funsafe-math-optimizations -ftree-vectorize \
    -c -o $OUTDIR/libmlirmatmuls.o $OUTDIR/libmlirmatmuls.ll

ar -rv $OUTDIR/libmlirmatmuls.a $OUTDIR/libmlirmatmuls.o

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang -shared -o $OUTDIR/libmlirmatmuls.so $OUTDIR/libmlirmatmuls.o \
    --target=arm-linux-gnueabihf \
    -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -lmlir_runner_utils -lmlir_axi_runner_utils
   
done

set +e
set +x
