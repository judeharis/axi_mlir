$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \
  -test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=0,2,1 opcode-map=\"opcode_map<s0=[op_send_literal(1),op_send_literal(4210752), op_send(0)], s1c=[op_send_literal(14),op_send_literal(4210752), op_send(1)], r=[op_recv(2)]>\" opcode-flow=\"(s0 (s1c r))\" accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2  anchor-filter=ACC_v4_As_64_64_64_0" \
  -test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=0,1,2 opcode-map=\"opcode_map<s=[op_send_literal(7),op_send_literal(4210752), op_send(0), op_send(1)], r=[op_send_literal(8),op_send_literal(4210752), op_recv(2)]>\" opcode-flow=\"((s) r)\" accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2  anchor-filter=ACC_v4_Cs_64_64_64_1" \
  -test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=1,2,0 opcode-map=\"opcode_map<s1=[op_send_literal(2),op_send_literal(1114128), op_send(1)], s0c=[op_send_literal(13),op_send_literal(1114128), op_send(0)], r=[op_recv(2)]>\" opcode-flow=\"(s1 (s0c r))\" accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2  anchor-filter=ACC_v4_Bs_16_256_16_2" \
  -test-generic-to-accel="anchor-op=linalg.matmul loop-permutation=0,1,2 opcode-map=\"opcode_map<s=[op_send_literal(7),op_send_literal(2129952), op_send(0), op_send(1)], r=[op_send_literal(8),op_send_literal(2129952), op_recv(2)]>\" opcode-flow=\"((s) r)\" accel-tile-size=${ACCEL_SIZE} acc-on-cpu=2  anchor-filter=ACC_v4_Cs_32_128_32_3" \
  -cse -test-accel-to-axi4mlir \
  -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting --buffer-deallocation \
  -convert-scf-to-cf \
  -arith-expand \
  -memref-expand \
  -convert-vector-to-llvm \
  -convert-memref-to-llvm="index-bitwidth=$BITW" \
  -convert-scf-to-cf \
  -convert-arith-to-llvm="index-bitwidth=$BITW" \
  -convert-std-to-llvm="index-bitwidth=$BITW" \
  -canonicalize \
  -reconcile-unrealized-casts \
  srcs/mlir_matmuls.mlir \
  -o $OUTDIR/llvm_acc${ACCEL_SIZE}_${ACCEL_TYPE}.mlir
