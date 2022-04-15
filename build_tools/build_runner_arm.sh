#!/bin/bash
# Copyright 2020 The TensorFlow Authors. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script was modified from:
# https://raw.githubusercontent.com/tensorflow/mlir-hlo/master/build_tools/build_mlir.sh

set -e

if [[ $# -ne 3 ]] ; then
  echo "Usage: $0 <path/to/llvm> <build_dir> <install_dir>"
  exit 1
fi

# LLVM source
LLVM_SRC_DIR=$(realpath --canonicalize-missing "$1")
build_dir=$(realpath --canonicalize-missing "$2")
install_dir=$(realpath --canonicalize-missing "$3")
suffix=-runner-arm

clang_tablegen=$build_dir-tblgen-x86/bin/clang-tblgen
llvm_tablegen=$build_dir-tblgen-x86/bin/llvm-tblgen
mlir_tablegen=$build_dir-tblgen-x86/bin/mlir-tblgen
linalg_ogs=$build_dir-x86/bin/mlir-linalg-ods-yaml-gen

if ! [ -f "$LLVM_SRC_DIR/llvm/CMakeLists.txt" ]; then
  echo "Expected the path to LLVM to be set correctly (got '$LLVM_SRC_DIR'): can't find CMakeLists.txt"
  exit 1
fi
echo "Using LLVM source dir: $LLVM_SRC_DIR"


# Setup directories.
echo "Building MLIR for host in $build_dir$suffix"
mkdir -p "$build_dir$suffix"
echo "Creating directory to install: $install_dir$suffix"
mkdir -p "$install_dir$suffix"

echo "Beginning build (commands will echo)"
set -x
  
# Options to target armv7
  # -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc-7 \
  # -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++-7 \
  # -DCMAKE_CROSSCOMPILING=True \
  # -DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf \
  # -DLLVM_TARGET_ARCH=ARM \
  # -DLLVM_TARGETS_TO_BUILD=ARM  \
  # -DCMAKE_CXX_FLAGS='-fcompare-debug-second' \

# Options to target AArch64
  #   -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc \
  # -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ \
  # -DCMAKE_CROSSCOMPILING=True \
  # -DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-linux-gnu \
  # -DLLVM_TARGET_ARCH=AArch64 \
  # -DLLVM_TARGETS_TO_BUILD=AArch64  \
  
# Options required if compiling clang or llvm
  # -DCLANG_TABLEGEN=$clang_tablegen \
  # -DLLVM_TABLEGEN=$llvm_tablegen \
  # -DMLIR_LINALG_ODS_YAML_GEN=$linalg_ogs \

cmake -GNinja \
  "-H$LLVM_SRC_DIR/llvm" \
  "-B$build_dir$suffix" \
  -DCMAKE_INSTALL_PREFIX=$install_dir$suffix  \
  -DMLIR_TABLEGEN=$mlir_tablegen \
  -DLLVM_TABLEGEN=$llvm_tablegen \
  -DMLIR_LINALG_ODS_YAML_GEN=$linalg_ogs \
  -DLLVM_INSTALL_UTILS=OFF  \
  -DLLVM_ENABLE_LLD=OFF   \
  -DLLVM_ENABLE_PROJECTS="mlir" \
  -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc-7 \
  -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++-7 \
  -DCMAKE_CXX_FLAGS='-fcompare-debug-second' \
  -DCMAKE_CROSSCOMPILING:BOOL=ON \
  -DAXI_CROSSCOMPILING:BOOL=ON \
  -DLLVM_DEFAULT_TARGET_TRIPLE=arm-linux-gnueabihf \
  -DLLVM_TARGET_ARCH=ARM \
  -DLLVM_TARGETS_TO_BUILD=ARM  \
  -DLLVM_BUILD_TOOLS=OFF   \
  -DLLVM_INCLUDE_TESTS=OFF   \
  -DMLIR_INCLUDE_TESTS=OFF   \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_BUILD_EXAMPLES=OFF

cmake --build "$build_dir$suffix" --target mlir-opt mlir-translate mlir_c_runner_utils mlir_runner_utils mlir_axi_runner_utils mlir_mockaxi_runner_utils

set +x
