
  # -test-generic-to-accel="anchor-op=linalg.conv_2d_nhwc_hwcf loop-permutation=0,1,2 opcode-map=\"opcode_map<s=[op_send(0), op_send(1)], r=[op_recv(2)]>\" opcode-flow=\"(s r)\", accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2 anchor-filter=ACC_v1_Ns" \

$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
  -convert-linalg-to-affine-loops \
  -lower-affine \
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
  srcs/mlir_conv2ds.mlir \
  -o $OUTDIR/llvm_acc_${ACCEL_TYPE}.mlir 
  # \
  # -print-ir-after-all 2>&1 | cat > $OUTDIR/intermediate_acc_${ACCEL_TYPE}.mlir
