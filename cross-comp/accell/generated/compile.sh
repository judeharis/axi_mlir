#!/bin/bash

set -e -o pipefail
set -x

# This is not the right target
# target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
# target triple = "armv7-none-linux-android"

OUTDIR=output
export PROJ_ROOT=/working_dir
mkdir -p $OUTDIR

APICC=$PROJ_ROOT/llvm-project/mlir/lib/ExecutionEngine/axi
BITW=64


# CONFIGS
KERNEL_NAME=matmul
ACCEL_SIZE=4
STRATEGY=MEM
SHARED_DIM=64

M=$SHARED_DIM
N=$SHARED_DIM
K=$SHARED_DIM
DIMS=m${M}_n${N}_k${K}
CALL_NAME=${KERNEL_NAME}_${DIMS}_${STRATEGY}
MLIR_CALL=${CALL_NAME}_call
MLIRMATMULCALL=$MLIR_CALL
CIMLIRMATMULCALL=_mlir_ciface_$MLIR_CALL

MLIR_CPU_CALL=${CALL_NAME}_call
MLIRMATMULCALLCPU=${MLIR_CPU_CALL}
CIMLIRMATMULCALLCPU=_mlir_ciface_${MLIR_CPU_CALL}

RUN_NAME=${KERNEL_NAME}-${DIMS}-${STRATEGY}-acc$ACCEL_SIZE
APPNAME=driver-${RUN_NAME}-app

# Declare an array of string with type
declare -a AccelSizeArray=(
    "4"
)

# Iterate the string array using for loop
for ACCEL_SIZE in ${AccelSizeArray[@]}; do
 
# Adding the emit-c-wrappers options affect every function declared inside the mlir file
#-convert-std-to-llvm="index-bitwidth=$BITW emit-c-wrappers" \
    # -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting --buffer-deallocation \

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
    -test-linalg-to-axi4mlir="flow-cpu-accumulation tile-sizes=128,128,128,32,32,32 accel-tile-size=${ACCEL_SIZE}" \
    -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting --buffer-deallocation \
    -convert-scf-to-cf  \
    -arith-expand \
    -memref-expand \
    -convert-vector-to-llvm \
    -convert-memref-to-llvm="index-bitwidth=$BITW" \
    -convert-scf-to-cf  \
    -convert-arith-to-llvm="index-bitwidth=$BITW" \
    -convert-std-to-llvm="index-bitwidth=$BITW" \
    -canonicalize \
    -reconcile-unrealized-casts \
    srcs/mlir_matmuls.mlir \
    -o $OUTDIR/llvm.mlir  
    # \
    # -print-ir-after-all 2>&1 | cat > intermediate.mlir

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-translate --mlir-to-llvmir $OUTDIR/llvm.mlir -o $OUTDIR/libmlirmatmuls.ll

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ \
    --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
    -mfpu=neon -funsafe-math-optimizations -ftree-vectorize \
    -c -o $OUTDIR/libmlirmatmuls.o $OUTDIR/libmlirmatmuls.ll

# No need for a static library
# ar -rv $OUTDIR/libmlirmatmuls.a $OUTDIR/libmlirmatmuls.o

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -shared -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}.so $OUTDIR/libmlirmatmuls.o \
    --target=arm-linux-gnueabihf \
    -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -lmlir_runner_utils -lmlir_axi_runner_utils
done

# Declare an array of string with type
declare -a StringArray=(
    "mlir_matmuls"
)

# Iterate the string array using for loop
for INPUT in ${StringArray[@]}; do

    #TODO if MANUAL Strategy, make empty
    #TODO if
    ADDITIONAL_FLAGS=-DRUNMLIR

    # Use this to include the standalone AXI lib for C++ drivers
    $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -o $OUTDIR/$APPNAME \
        srcs/matmul_driver_v3.cc \
        -Isrcs \
        -I$PROJ_ROOT/llvm-project/mlir/include \
        --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
        -mfpu=neon -funsafe-math-optimizations -ftree-vectorize \
        -Wl,--copy-dt-needed-entries \
        -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
        -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
        -lmlir_runner_utils -lmlir_c_runner_utils -lmlir_axi_runner_utils \
        -L$OUTDIR \
        -lmlirmatmuls_acc${ACCEL_SIZE} \
        -Dtile_M=$ACCEL_SIZE \
        -Dtile_N=$ACCEL_SIZE \
        -Dtile_K=$ACCEL_SIZE \
        -DM=$M \
        -DN=$N \
        -DK=$K \
        -DMLIRMATMULCALL=$MLIRMATMULCALL \
        -DCIMLIRMATMULCALL=$CIMLIRMATMULCALL \
        -DMLIRMATMULCALLCPU=$MLIRMATMULCALLCPU \
        -DCIMLIRMATMULCALLCPU=$CIMLIRMATMULCALLCPU \
        -DRUNMLIR

        # -DRUNCPP \
done

set +e
set +x