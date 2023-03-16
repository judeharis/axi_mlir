$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
  -test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=0,2,1 opcode-map=\"opcode_map<s0=[op_send_literal(1), op_send(0)], s1c=[op_send_literal(6), op_send(1)], r=[op_recv(2)]>\" opcode-flow=\"(s0 (s1c r))\" accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2" \
  -cse -test-accel-to-axi4mlir \
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
  -o $OUTDIR/llvm.mlir \
  -print-ir-after-all 2>&1 | cat > $OUTDIR/intermediate.mlir
