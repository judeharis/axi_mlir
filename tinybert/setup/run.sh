#!/bin/bash


export PATH=$PATH:/working_dir/builds/soda-opt/build/bin
export PATH=$PATH:/working_dir/builds/llvm-project/build/bin

# Convert from linalg with tensors to linalg on buffers.
mlir-opt \
  -pass-pipeline="any( tosa-to-arith{include-apply-rescale=true}, tosa-to-linalg-named, tosa-to-linalg)" \
  --canonicalize \
  -convert-tensor-to-linalg \
  -linalg-init-tensor-to-alloc-tensor \
  -eliminate-alloc-tensors \
  -linalg-bufferize -arith-bufferize \
  -tensor-bufferize -func-bufferize \
  -finalizing-bufferize -buffer-deallocation \
  --buffer-results-to-out-params \
  --canonicalize -cse \
  tinybert-linalg_on_tensors.mlir \
  -o tinybert-linalg_buffers.mlir


soda-opt tinybert-linalg_buffers.mlir --lower-all-to-llvm -o llmv.mlir

mlir-translate -opaque-pointers=0  \
    --mlir-to-llvmir \
    llmv.mlir \
    -o llvm.ll
