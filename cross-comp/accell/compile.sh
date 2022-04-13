#!/bin/bash

set -e -o pipefail
set -x

# This is not the right target
# target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
# target triple = "armv7-none-linux-android"

export PROJ_ROOT=/working_dir

BITW=64

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
        -test-linalg-to-axi4mlir="flow-cpu-accumulation" \
        -convert-linalg-to-loops -convert-scf-to-cf   \
        -arith-expand \
        -memref-expand \
        -convert-vector-to-llvm \
        -convert-memref-to-llvm="index-bitwidth=$BITW" \
        -convert-arith-to-llvm="index-bitwidth=$BITW" \
        -convert-std-to-llvm="index-bitwidth=$BITW" \
        -reconcile-unrealized-casts \
        $PROJ_ROOT/llvm-project/mlir/test/axi4mlir-runner/run-matmul-v1accel.mlir \
        -o llvm.mlir \
        -print-ir-before-all 2>&1 | cat > intermediate.mlir

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-translate --mlir-to-llvmir llvm.mlir -o app.ll

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang -g \
    --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
    -c -o app.o app.ll

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang -g -o app app.o \
    --target=arm-linux-gnueabihf \
    -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -lmlir_runner_utils -lmlir_axi_runner_utils

set +e
set +x
