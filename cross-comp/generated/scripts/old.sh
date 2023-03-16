$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
  -test-matmul-to-accel \
  -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting --buffer-deallocation \
  -convert-scf-to-cf \
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