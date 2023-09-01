#!/bin/bash

PROJ_ROOT=/working_dir
MLIR_BIN=$PROJ_ROOT/builds/llvm-project/build-x86/bin/

# TOSA to Linalg
$MLIR_BIN/mlir-opt \
  --tosa-to-linalg-named \
  --tosa-to-linalg \
  -linalg-bufferize \
  -arith-bufferize -tensor-bufferize -func-bufferize \
  -finalizing-bufferize -buffer-deallocation \
  -canonicalize \
  -cse \
  conv2d_tosa.mlir \
  -o outs/conv2d_linalg.mlir


# linalg to affine
$MLIR_BIN/mlir-opt \
  -convert-linalg-to-affine-loops \
  conv2d_linalg.mlir  \
  -o outs/conv2d_affine.mlir

# affine to SCF
$MLIR_BIN/mlir-opt \
  -lower-affine \
  -cse \
  outs/conv2d_affine.mlir \
  -o outs/conv2d_scf.mlir

# for conv2d_nchw_fchw, tile sizes respect the loops:
# b,oc,oh,ow,ic,fh,fw
# linalg to affine
$MLIR_BIN/mlir-opt \
  -linalg-tile=tile-sizes=1,1,1,1 \
  -convert-linalg-to-loops \
  -lower-affine \
  -cse -test-accel-to-axi4mlir \
  -cse \
  conv2d_linalg.mlir  \
  -o outs/conv2d_scf_tiled.mlir

# affine to SCF
# $MLIR_BIN/mlir-opt \
#   -lower-affine \
#   -cse \
#   outs/conv2d_affine_tiled.mlir \
#   -o outs/conv2d_scf_tiled.mlir