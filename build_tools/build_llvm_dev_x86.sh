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
suffix=-x86

if ! [ -f "$LLVM_SRC_DIR/llvm/CMakeLists.txt" ]; then
  echo "Expected the path to LLVM to be set correctly (got '$LLVM_SRC_DIR'): can't find CMakeLists.txt"
  exit 1
fi
echo "Using LLVM source dir: $LLVM_SRC_DIR"


# Setup directories.
echo "Building MLIR for host in $build_dir-arm"
mkdir -p "$build_dir-arm"
echo "Creating directory to install: $install_dir-arm"
mkdir -p "$install_dir-arm"

echo "Beginning build (commands will echo)"
set -x

cmake -GNinja \
  "-H$LLVM_SRC_DIR/llvm" \
  "-B$build_dir$suffix" \
  -DCMAKE_C_COMPILER=clang-10 \
  -DCMAKE_CXX_COMPILER=clang++-10 \
  -DCMAKE_INSTALL_PREFIX=$install_dir$suffix  \
  -DLLVM_INSTALL_UTILS=ON   \
  -DLLVM_ENABLE_LLD=ON   \
  -DLLVM_ENABLE_PROJECTS="clang;llvm;mlir"   \
  -DLLVM_TARGET_ARCH="host" \
  -DLLVM_TARGETS_TO_BUILD="host;ARM;AArch64"   \
  -DLLVM_INCLUDE_TOOLS=ON   \
  -DLLVM_BUILD_TOOLS=OFF   \
  -DLLVM_INCLUDE_TESTS=ON   \
  -DMLIR_INCLUDE_TESTS=ON   \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DLLVM_ENABLE_ASSERTIONS=On \
  -DLLVM_BUILD_EXAMPLES=OFF

cmake --build "$build_dir$suffix" --target clang opt mlir-opt mlir-translate mlir-cpu-runner mlir_c_runner_utils mlir_runner_utils mlir_axi_runner_utils mlir_mockaxi_runner_utils FileCheck --target install

set +x