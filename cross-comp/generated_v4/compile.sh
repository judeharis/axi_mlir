#!/bin/bash

# ./compile.sh [target] [debug]
# target: arm*, sysc
# debug: 0*, 1
#example: ./compile.sh # default target is arm and debug is 0
#example: ./compile.sh arm 1
#example: ./compile.sh sysc 1

# This will generate a folder called output with the contents:
# driver-matmul-m128_n128_k128-ACC-acc16_v1_Ns-app
# driver-matmul-m128_n128_k128-MAN-acc16_v2_Ns-app
# intermediate_acc16_v1.mlir libmlirmatmuls_acc16_v1.ll etc...

# all apps end in `*-app``.
# Run this line to execute each app after waiting for an user input:
# for i in `ls -1 output/*-app`; do echo "Start $i?"; read; ./$i; echo "Finished $i"; done

set -e -o pipefail
# set -x

# This is not the right target
# target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
# target triple = "armv7-none-linux-android"

OUTDIR=output
export PROJ_ROOT=/working_dir

rm -rf $OUTDIR
mkdir -p $OUTDIR

APICC=$PROJ_ROOT/llvm-project/mlir/lib/ExecutionEngine/axi
BITW=64

TARGET=arm
DBG=0
TEST=0
# TARGET=sysc
# Default above, but we can change it based on the first argument
if [ $# -eq 1 ]; then
  TARGET=$1
fi

# if there are two arguments, then the second one is the debug flag
if [ $# -eq 2 ]; then
  TARGET=$1
  DBG=$2
fi

# if there are two arguments, then the second one is the debug flag
if [ $# -eq 3 ]; then
  TARGET=$1
  DBG=$2
  TEST=$3
fi

# Static CONFIGS
KERNEL_NAME=matmul
ACCEL_SIZE=16
ACCEL_TYPE=v4
STRATEGY=ACC
PROBLEM_DIM=64

# ===========================
# Declaring input arrays

declare -a AccelTypeArray=(
  "v4"
)

declare -a KernelNameArray=(
  "matmul"
)

source ./generate_all.sh
source ./srcs/array.sh

# ===========================
# Compiling mlir matmul library for a given accelerator size
echo "Compiling mlir matmul library for a given accelerator size..."

# Iterate the string array using for loop
# for ACCEL_SIZE in ${AccelSizeArray[@]}; do
#   for ACCEL_TYPE in ${AccelTypeArray[@]}; do

# Call the script that performs the MLIR compilation
source srcs/compile_mlir_matmul-all.sh


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

  SYSC_LIB=-lmlir_syscaxi_runner_utils
  if [ "$ACCEL_TYPE" == "v4" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_accv4
  fi

  $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -shared \
    -o $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.so \
    $OUTDIR/libmlirmatmuls_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
    -L$PROJ_ROOT/builds/llvm-project/build-x86/lib \
    -lmlir_runner_utils $SYSC_LIB
fi

echo "... Done compiling mlir matmul library for a given accelerator size."

# ===========================
# Compiling output binary for a given problem, strategy, accel size
echo "Compiling output binary for a given problem, strategy, accel size..."

install -m 777 /dev/null $OUTDIR/appslist.sh
echo "declare -a AppArray=(" >$OUTDIR/appslist.sh

length=${#TagArray[@]}
for ((j = 0; j < length; j++)); do

  # ACCEL_SIZE=${TileNArray[$j]}
  FLOW=${FlowArray[$j]}

  TILE_M=${TileMArray[$j]}
  TILE_N=${TileNArray[$j]}
  TILE_K=${TileKArray[$j]}

  M=${MArray[$j]}
  N=${NArray[$j]}
  K=${KArray[$j]}
  DIMS=m${M}_n${N}_k${K}
  CALL_NAME=${KERNEL_NAME}_${DIMS}_${TagArray[$j]}
  MLIR_CALL=${CALL_NAME}_call
  MLIRMATMULCALL=$MLIR_CALL
  CIMLIRMATMULCALL=_mlir_ciface_$MLIR_CALL

  MLIR_CPU_CALL=${KERNEL_NAME}_${DIMS}_${TagArray[$j]}_call
  MLIRMATMULCALLCPU=${MLIR_CPU_CALL}
  CIMLIRMATMULCALLCPU=_mlir_ciface_${MLIR_CPU_CALL}

  RUN_NAME=${KERNEL_NAME}-${DIMS}-${TagArray[$j]}-${STRATEGY}
  APPNAME=driver-${RUN_NAME}-app

  echo "    ${APPNAME}" >>$OUTDIR/appslist.sh

  if [ "$STRATEGY" == "ACC" ]; then
    ADDITIONAL_FLAGS=-DRUNMLIR
  else
    ADDITIONAL_FLAGS="-DRUNCPP -DACCv4${FLOW} -Dblock_M=$TILE_M -Dblock_N=$TILE_N -Dblock_K=$TILE_K"
  fi

  # ADDITIONAL_FLAGS=-DRUNMLIR
  # set -x
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
      -Dtile_M=$TILE_M \
      -Dtile_N=$TILE_N \
      -Dtile_K=$TILE_K \
      -DM=$M \
      -DN=$N \
      -DK=$K \
      -DMLIRMATMULCALL=$MLIRMATMULCALL \
      -DCIMLIRMATMULCALL=$CIMLIRMATMULCALL \
      -DMLIRMATMULCALLCPU=$MLIRMATMULCALLCPU \
      -DCIMLIRMATMULCALLCPU=$CIMLIRMATMULCALLCPU \
      -DACCV=$ACCEL_TYPE \
      -DDBG=$DBG \
      -DTEST=$TEST \
      $ADDITIONAL_FLAGS

  elif [ $TARGET == "sysc" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils
    if [ "$ACCEL_TYPE" == "v4" ]; then
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
      -Dtile_M=$TILE_M \
      -Dtile_N=$TILE_N \
      -Dtile_K=$TILE_K \
      -DM=$M \
      -DN=$N \
      -DK=$K \
      -DMLIRMATMULCALL=$MLIRMATMULCALL \
      -DCIMLIRMATMULCALL=$CIMLIRMATMULCALL \
      -DMLIRMATMULCALLCPU=$MLIRMATMULCALLCPU \
      -DCIMLIRMATMULCALLCPU=$CIMLIRMATMULCALLCPU \
      -DSYSC_T \
      -DACCV=$ACCEL_TYPE \
      -DDBG=$DBG \
      -DTEST=$TEST \
      $ADDITIONAL_FLAGS
  fi
  # set +x
done #TagArray
echo ")" >>$OUTDIR/appslist.sh

echo "... Done compiling apps"

if [ $TARGET == "sysc" ]; then
  echo 'length=${#AppArray[@]}' >>$OUTDIR/appslist.sh
  echo 'for ((j = 0; j < length; j++)); do' >>$OUTDIR/appslist.sh
  echo '  ./output/${AppArray[$j]}' >>$OUTDIR/appslist.sh
  echo 'done' >>$OUTDIR/appslist.sh
  echo ""
  echo "WARNING: Runing systemc simulation requires to export the LD_LIBRARY_PATH"
  echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PROJ_ROOT/cross-comp/generated_v4/output:/working_dir/builds/llvm-project/build-x86/lib"
fi

set +e
# set +x
