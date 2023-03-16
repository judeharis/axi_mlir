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
#     "MANUAL" # TODO manual is not working, need to fix
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

# Declare scripts because the commandline has different types of quotation marks
# note that filename is importatnt as it will be split into
#    compile_mlir_matmul-${ACCEL_TYPE}.sh
declare -a AccelTypeScriptArray=(
    scripts/compile_mlir_matmul-v1_Ns.sh
    # scripts/compile_mlir_matmul-v2_Ns.sh
    # scripts/compile_mlir_matmul-v2_As.sh
    # scripts/compile_mlir_matmul-v2_Bs.sh
)

declare -a KernelNameArray=(
    "matmul"
)

declare -a StrategyArray=(
    "OVERRRIDEN_BY_SCRIPT"
    # "MEM"
    # "L2"
    # "L1"
    # "CPU"
    # "MANUAL" # TODO manual is not working, need to fix
)

declare -a ProblemDimArray=(
    "4"
    # "8"
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
for ACCEL_TYPE_SCRIPT in ${AccelTypeScriptArray[@]}; do

ACCEL_TYPE=$(echo $ACCEL_TYPE_SCRIPT | cut -d'-' -f2 | cut -d'.' -f1)

# Call the script that performs the MLIR compilation 
source $ACCEL_TYPE_SCRIPT

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-translate --mlir-to-llvmir $OUTDIR/llvm.mlir -o $OUTDIR/libmlirmatmuls.ll

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ \
    --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
    -mfpu=neon -funsafe-math-optimizations -ftree-vectorize \
    -c -o $OUTDIR/libmlirmatmuls.o $OUTDIR/libmlirmatmuls.ll

# No need for a static library
# ar -rv $OUTDIR/libmlirmatmuls.a $OUTDIR/libmlirmatmuls.o

$PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -shared -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.so $OUTDIR/libmlirmatmuls.o \
    --target=arm-linux-gnueabihf \
    -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
    -lmlir_runner_utils -lmlir_axi_runner_utils

done
done

# ===========================
# Compiling output binary for a given problem, strategy, accel size

# Iterate the string array using for loop
# for STRATEGY in ${StrategyArray[@]}; do
for ACCEL_TYPE_SCRIPT in ${AccelTypeScriptArray[@]}; do
for KERNEL_NAME in ${KernelNameArray[@]}; do
for PROBLEM_DIM in ${ProblemDimArray[@]}; do
for ACCEL_SIZE in ${AccelSizeArray[@]}; do

if [ "$ACCEL_SIZE" -gt "$PROBLEM_DIM" ]; then
  continue
fi


# TODO: For now, strategy is overriden by the script
ACCEL_TYPE=$(echo $ACCEL_TYPE_SCRIPT | cut -d'-' -f2 | cut -d'.' -f1)
STRATEGY=$ACCEL_TYPE

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
    -lmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE} \
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