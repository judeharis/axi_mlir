#!/bin/bash

# ./compile.sh [target] [debug]
# target: arm*, sysc
# debug: 0*, 1
#example: ./compile.sh # default target is arm and debug is 0
#example: ./compile.sh arm 1
#example: ./compile.sh sysc 1

# This will generate a folder called output with the contents:
# driver-conv2d-m128_n128_k128-ACC-acc16_v1_Ns-app
# driver-conv2d-m128_n128_k128-MAN-acc16_v2_Ns-app
# intermediate_acc16_v1.mlir libmlirconv2ds_acc16_v1.ll etc...

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

# if there are three arguments, then the third one is the test flag
if [ $# -eq 3 ]; then
  TARGET=$1
  DBG=$2
  TEST=$3
fi

# Static CONFIGS
KERNEL_NAME=conv2d
STRATEGY=MAN


# ===========================
# Declaring input arrays

declare -a AccelTypeArray=(
  "v3"
)

declare -a KernelNameArray=(
  "conv2d"
)

source ./generate_all.sh
source ./generated/array.sh

# ===========================
# Compiling mlir conv2d library for a given accelerator size
echo "Compiling mlir conv2d library for a given accelerator size..."

# Iterate the string array using for loop
for ACCEL_TYPE in ${AccelTypeArray[@]}; do

# Call the script that performs the MLIR compilation
source scripts/compile_mlir_conv2d-all.sh

## This generated .ll file
# $PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-translate --mlir-to-llvmir \
#   -o $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.ll \
#   $OUTDIR/llvm_acc${ACCEL_SIZE}_${ACCEL_TYPE}.mlir

## Using the .ll file generated above, we can compile it to a .so file
# if target is do what is below, else link the systemc library
# if [ $TARGET == "arm" ]; then
#   $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ \
#     --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
#     -mfpu=neon -funsafe-math-optimizations -ftree-vectorize \
#     -c -o $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
#     $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.ll

#   $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -shared \
#     -o $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.so \
#     $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
#     --target=arm-linux-gnueabihf \
#     -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
#     -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
#     -lmlir_runner_utils -lmlir_axi_runner_utils
# elif [ $TARGET == "sysc" ]; then
#   $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ \
#     -c -o $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
#     $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.ll
#   SYSC_LIB=-lmlir_syscaxi_runner_utils
#   if [ "$ACCEL_TYPE" == "v4" ]; then
#     SYSC_LIB=-lmlir_syscaxi_runner_utils_accv4
#   fi
#   $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -shared \
#     -o $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.so \
#     $OUTDIR/libmlirconv2ds_acc${ACCEL_SIZE}_${ACCEL_TYPE}.o \
#     -L$PROJ_ROOT/builds/llvm-project/build-x86/lib \
#     -lmlir_runner_utils $SYSC_LIB
# fi
done # ACCEL_TYPE
echo "... Done compiling mlir conv2d library for a given accelerator size."



# ===========================
# Compiling output binary for a given problem
echo "Compiling output binary for a given problem..."

install -m 777 /dev/null $OUTDIR/appslist.sh

echo "declare -a AppArray=(" >$OUTDIR/appslist.sh
length=${#TagArray[@]}
for ((j = 0; j < length; j++)); do
  B=${BArray[$j]}
  IHW=${IHWArray[$j]}
  IC=${ICArray[$j]}
  FHW=${FHWArray[$j]}
  OC=${OCArray[$j]}
  ST=${STArray[$j]}
  DIMS=b${B}_ihw${IHW}_ic${IC}_fhw${FHW}_oc${OC}_st${ST}


  # RUN_NAME=${KERNEL_NAME}-${DIMS}-${TagArray[$j]}-${STRATEGY}
  RUN_NAME=${KERNEL_NAME}-${TagArray[$j]}

  APPNAME=driver-${RUN_NAME}-app
  echo "    ${APPNAME}" >>$OUTDIR/appslist.sh

  if [ "$STRATEGY" == "ACC" ]; then
    ADDITIONAL_FLAGS=-DRUNMLIR
  else
    ADDITIONAL_FLAGS="-DRUNCPP"
  fi

  # set -x
  if [ $TARGET == "arm" ]; then
    $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -o $OUTDIR/$APPNAME \
      srcs/conv_driver_v1.cc \
      -Isrcs \
      -I$PROJ_ROOT/llvm-project/mlir/include \
      --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard \
      -mfpu=neon -funsafe-math-optimizations -ftree-vectorize \
      -Wl,--copy-dt-needed-entries \
      -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
      -L$PROJ_ROOT/builds/llvm-project/build-runner-arm/lib \
      -lmlir_runner_utils -lmlir_c_runner_utils -lmlir_axi_runner_utils \
      -L$OUTDIR \
      -DB=$B \
      -DIHW=$IHW \
      -DIC=$IC \
      -DFHW=$FHW \
      -DOC=$OC \
      -DST=$ST \
      -DDBG=$DBG \
      -DTEST=$TEST \
      $ADDITIONAL_FLAGS

  elif [ $TARGET == "sysc" ]; then
    SYSC_LIB=-lmlir_syscaxi_runner_utils_conv_accv3
    $PROJ_ROOT/builds/llvm-project/build-x86/bin/clang++ -o $OUTDIR/$APPNAME \
      srcs/conv_driver_v1.cc \
      -Isrcs \
      -I$PROJ_ROOT/llvm-project/mlir/include \
      -Wl,--copy-dt-needed-entries \
      -Wl,-rpath=$PROJ_ROOT/builds/llvm-project/build-x86/lib \
      -L$PROJ_ROOT/builds/llvm-project/build-x86/lib \
      -lmlir_runner_utils $SYSC_LIB \
      -L$OUTDIR \
      -DB=$B \
      -DIHW=$IHW \
      -DIC=$IC \
      -DFHW=$FHW \
      -DOC=$OC \
      -DST=$ST \
      -DSYSC_T \
      -DDBG=$DBG \
      -DTEST=$TEST \
      -DCONV_V3 \
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
  echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PROJ_ROOT/api_tester_conv_driver_v1/output:/working_dir/builds/llvm-project/build-x86/lib"

  # echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PROJ_ROOT/cross-comp/generated_v4/output:/working_dir/builds/llvm-project/build-x86/lib"
fi

set +e
# set +x
