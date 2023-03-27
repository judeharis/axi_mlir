#!/bin/bash

set -e -o pipefail
# set -x

# This is not the right target
# target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
# target triple = "armv7-none-linux-android"

OUTDIR=output
export PROJ_ROOT=/working_dir
mkdir -p $OUTDIR

APICC=$PROJ_ROOT/llvm-project/mlir/lib/ExecutionEngine/axi
BITW=64

TARGET=arm
# TARGET=sysc
# Default above, but we can change it based on the first argument
if [ $# -eq 1 ]; then
  TARGET=$1
fi

# Static CONFIGS
KERNEL_NAME=matmul
ACCEL_SIZE=4
ACCEL_TYPE=v1
FLOW=Ns
STRATEGY=ACCELERATE
PROBLEM_DIM=64


# ===========================
# Declaring input arrays

declare -a AccelSizeArray=(
    "4"
    "8"
    "16"
)

declare -a AccelTypeArray=(
    "v1"
    "v2"
    "v3"
    # "v4"
)

declare -a KernelNameArray=(
    "matmul"
)

declare -a FlowArray=(
    "NA"
    "Ns"
    "As"
    "Bs"
    "Cs"
)

declare -a StrategyArray=(
    "ACC"
    # "MEM"
    # "L2"
    # "L1"
    "CPU"
    # "MAN"
)

declare -a ProblemDimArray=(
    # "4"
    # "8"
    "16"
    "32"
    "64"
    "128"
    "256"
    # "512"
)

# ===========================
# Compiling mlir matmul library for a given accelerator size
echo "Compiling mlir matmul library for a given accelerator size..."

# Iterate the string array using for loop
for ACCEL_SIZE in ${AccelSizeArray[@]}; do
for ACCEL_TYPE in ${AccelTypeArray[@]}; do

# Call the script that performs the MLIR compilation 
source scripts/compile_mlir_matmul-all.sh

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-translate --mlir-to-llvmir \
    -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.ll \
    $OUTDIR/llvm_acc${ACCEL_SIZE}_${ACCEL_TYPE}.mlir

# if target is do what is below, else link the systemc library

if [ $TARGET == "arm" ]; then
  $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ \
      --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
      -mfpu=neon -funsafe-math-optimizations -ftree-vectorize \
      -c -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
      $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.ll

  # No need for a static library
  # ar -rv $OUTDIR/libmlirmatmuls.a $OUTDIR/libmlirmatmuls.o

  $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -shared \
      -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.so \
      $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
      --target=arm-linux-gnueabihf \
      -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
      -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
      -lmlir_runner_utils -lmlir_axi_runner_utils
elif [ $TARGET == "sysc" ]; then
  $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ \
      -c -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
      $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.ll

  # No need for a static library
  # ar -rv $OUTDIR/libmlirmatmuls.a $OUTDIR/libmlirmatmuls.o


  SYSC_LIB=-lmlir_syscaxi_runner_utils
  if [ "$ACCEL_TYPE" == "v1" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv1
  elif [ "$ACCEL_TYPE" == "v2" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv2
  elif [ "$ACCEL_TYPE" == "v3" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv3
  elif [ "$ACCEL_TYPE" == "v4" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv4
  fi

  $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -shared \
      -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.so \
      $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
      -L$PROJ_ROOT/builds/llvm-project/build-x86/lib \
      -lmlir_runner_utils $SYSC_LIB
fi

done # ACCEL_TYPE
done # ACCEL_SIZE
echo "... Done compiling mlir matmul library for a given accelerator size."

# ===========================
# Compiling output binary for a given problem, strategy, accel size
echo "Compiling output binary for a given problem, strategy, accel size..."

# Iterate the string array using for loop
for ACCEL_TYPE in ${AccelTypeArray[@]}; do
for FLOW in ${FlowArray[@]}; do
for STRATEGY in ${StrategyArray[@]}; do
for KERNEL_NAME in ${KernelNameArray[@]}; do
for PROBLEM_DIM in ${ProblemDimArray[@]}; do
for ACCEL_SIZE in ${AccelSizeArray[@]}; do

if [ "$STRATEGY" == "MAN" ] || [ "$STRATEGY" == "CPU" ]; then
  if [ "$FLOW" != "NA" ]; then
    continue
  fi
else
  if [ "$FLOW" == "NA" ]; then
    continue
  fi
fi

if [ "$ACCEL_SIZE" -gt "$PROBLEM_DIM" ]; then
  continue
fi

if [ "$ACCEL_TYPE" == "v1" ]; then
  if [ "$FLOW" == "As" ] || [ "$FLOW" == "Bs" ] || [ "$FLOW" == "Cs" ]; then
    continue
  fi
fi

if [ "$ACCEL_TYPE" == "v2" ]; then
  if [ "$FLOW" == "Cs" ]; then
    continue
  fi
fi

# if [ "$ACCEL_TYPE" == "v3" ]; then
# V3 supports all flows
# fi

M=$PROBLEM_DIM
N=$PROBLEM_DIM
K=$PROBLEM_DIM
DIMS=m${M}_n${N}_k${K}
CALL_NAME=${KERNEL_NAME}_${DIMS}_${STRATEGY}_${ACCEL_TYPE}_${FLOW}
MLIR_CALL=${CALL_NAME}_call
MLIRMATMULCALL=$MLIR_CALL
CIMLIRMATMULCALL=_mlir_ciface_$MLIR_CALL

MLIR_CPU_CALL=${KERNEL_NAME}_${DIMS}_${STRATEGY}_call
MLIRMATMULCALLCPU=${MLIR_CPU_CALL}
CIMLIRMATMULCALLCPU=_mlir_ciface_${MLIR_CPU_CALL}

RUN_NAME=${KERNEL_NAME}-${DIMS}-${STRATEGY}-acc${ACCEL_SIZE}_${ACCEL_TYPE}_${FLOW}
APPNAME=driver-${RUN_NAME}-app

if [ "$STRATEGY" == "MAN" ]; then
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

if [ $TARGET == "arm" ]; then
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
elif [ $TARGET == "sysc" ]; then
  SYSC_LIB=-lmlir_syscaxi_runner_utils
  if [ "$ACCEL_TYPE" == "v1" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv1
  elif [ "$ACCEL_TYPE" == "v2" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv2
  elif [ "$ACCEL_TYPE" == "v3" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv3
  elif [ "$ACCEL_TYPE" == "v4" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv4
  fi

  $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -o $OUTDIR/$APPNAME \
    srcs/matmul_driver_v3.cc \
    -Isrcs \
    -I$PROJ_ROOT/llvm-project/mlir/include \
    -Wl,--copy-dt-needed-entries \
    -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-x86/lib \
    -L$PROJ_ROOT/builds/llvm-project/build-x86/lib \
    -lmlir_runner_utils $SYSC_LIB \
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
fi

done #AccelSizeArray
done #ProblemDimArray
done #KernelNameArray
done #StrategyArray
done #FlowArray
done #AccelTypeArray

echo "... Done compiling apps"

if [ $TARGET == "sysc" ]; then
  echo ""
  echo "WARNING: Runing systemc simulation requires to export the LD_LIBRARY_PATH"
  echo "export LD_LIBRARY_PATH=$PROJ_ROOT/cross-comp/generated/output:/working_dir/builds/llvm-project/build-x86/lib"
fi

set +e
# set +x