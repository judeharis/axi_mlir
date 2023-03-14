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


# Static CONFIGS
KERNEL_NAME=matmul
ACCEL_SIZE=4
STRATEGY=ACCELERATE
PROBLEM_DIM=64


# ===========================
# Declaring input arrays

# Used by both MLIR MATMUL library and final app
# declare -a AccelSizeArray=(
#     "4"
#     "8"
#     "16"
# )

# declare -a KernelNameArray=(
#     "matmul"
# )

# declare -a StrategyArray=(
#     "MEM"
#     "L2"
#     "L1"
#     "CPU"
#     "MANUAL"
# )

# declare -a ProblemDimArray=(
#     "4"
#     "8"
#     "16"
#     "32"
#     "64"
#     "128"
#     "256"
#     "512"
# )

declare -a AccelSizeArray=(
    "4"
    # "8"
    # "16"
)

declare -a KernelNameArray=(
    "matmul"
)

declare -a StrategyArray=(
    # "MEM"
    # "L2"
    "L1"
    # "CPU"
    # "MANUAL"
)

declare -a ProblemDimArray=(
    "4"
    "8"
    # "16"
    # "32"
    # "64"
    # "128"
    # "256"
    # "512"
)

# ===========================
# Compiling mlir matmul library for a given accelerator size

# Iterate the string array using for loop
for ACCEL_SIZE in ${AccelSizeArray[@]}; do
 
# Adding the emit-c-wrappers options affect every function declared inside the mlir file
#-convert-std-to-llvm="index-bitwidth=$BITW emit-c-wrappers" \
    # -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting --buffer-deallocation \

 
    # V1
    # -test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=0,1,2 opcode-map=\"opcode_map<s=[op_send(0), op_send(1)], r=[op_recv(2)]>\" opcode-flow=\"(s r)\", accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2" \
    
    
    # V2 - Tiling1
    # -test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=0,1,2 opcode-map=\"opcode_map<s=[op_send_literal(7), op_send(0), op_send(1)], r=[op_recv(2)]>\" opcode-flow=\"(s r)\",  number-of-caches=2 tile-sizes=128,128,128,32,32,32 acc-on-cpu=2 accel-tile-size=${ACCEL_SIZE}" --cse \

    # V2 - Tiling2
    # --test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=0,2,1 opcode-map=\"opcode_map<s0=[op_send_literal(1), op_send(0)], s1c=[op_send_literal(6), op_send(1)], r=[op_recv(2)]>\" opcode-flow=\"(s0 (s1c r))\" accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2" --cse \

    # V2 - Tiling3 
    #    --test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=1,2,0 opcode-map=\"opcode_map<s1=[op_send_literal(2), op_send(1)], s0c=[op_send_literal(5), op_send(0)], r=[op_recv(2)]>\" opcode-flow=\"(s1 (s0c r))\" acc-on-cpu=2 accel-tile-size=4" --cse \

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
   --test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=1,2,0 opcode-map=\"opcode_map<s1=[op_send_literal(2), op_send(1)], s0c=[op_send_literal(5), op_send(0)], r=[op_recv(2)]>\" opcode-flow=\"(s1 (s0c r))\" acc-on-cpu=2 accel-tile-size=4" --cse \
    -test-accel-to-axi4mlir \
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

# ===========================
# Compiling output binary for a given problem, strategy, accel size

# Iterate the string array using for loop
for STRATEGY in ${StrategyArray[@]}; do
for KERNEL_NAME in ${KernelNameArray[@]}; do
for PROBLEM_DIM in ${ProblemDimArray[@]}; do
for ACCEL_SIZE in ${AccelSizeArray[@]}; do

if [ "$ACCEL_SIZE" -gt "$PROBLEM_DIM" ]; then
  continue
fi

M=$PROBLEM_DIM
N=$PROBLEM_DIM
K=$PROBLEM_DIM
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

if [ "$STRATEGY" == "MANUAL" ]; then
    # Compiling driver implemented by hand
    ADDITIONAL_FLAGS=-DRUNCPP
elif [ "$STRATEGY" == "CPU" ]; then
    # Compiling driver in MLIR without acceleration
    ADDITIONAL_FLAGS=""
    RUN_NAME=${KERNEL_NAME}-${DIMS}-${STRATEGY}-accNONE
    APPNAME=driver-${RUN_NAME}-app
else
    # Compiling driver implemented in MLIR
    ADDITIONAL_FLAGS=-DRUNMLIR
fi

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
    $ADDITIONAL_FLAGS

done #AccelSizeArray
done #ProblemDimArray
done #KernelNameArray
done #StrategyArray

set +e
set +x