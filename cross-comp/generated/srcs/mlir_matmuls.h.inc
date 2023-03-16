
// M=16 N=16 K=16
extern "C" void matmul_m16_n16_k16_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m16_n16_k16_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=32 N=32 K=32
extern "C" void matmul_m32_n32_k32_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m32_n32_k32_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=64 N=64 K=64
extern "C" void matmul_m64_n64_k64_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m64_n64_k64_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=128 N=128 K=128
extern "C" void matmul_m128_n128_k128_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m128_n128_k128_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=256 N=256 K=256
extern "C" void matmul_m256_n256_k256_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m256_n256_k256_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=512 N=512 K=512
extern "C" void matmul_m512_n512_k512_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m512_n512_k512_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=1024 N=1024 K=1024
extern "C" void matmul_m1024_n1024_k1024_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m1024_n1024_k1024_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=2048 N=2048 K=2048
extern "C" void matmul_m2048_n2048_k2048_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m2048_n2048_k2048_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=4096 N=4096 K=4096
extern "C" void matmul_m4096_n4096_k4096_ACC_v1_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m4096_n4096_k4096_ACC_v1_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=16 N=16 K=16
extern "C" void matmul_m16_n16_k16_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m16_n16_k16_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=32 N=32 K=32
extern "C" void matmul_m32_n32_k32_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m32_n32_k32_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=64 N=64 K=64
extern "C" void matmul_m64_n64_k64_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m64_n64_k64_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=128 N=128 K=128
extern "C" void matmul_m128_n128_k128_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m128_n128_k128_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=256 N=256 K=256
extern "C" void matmul_m256_n256_k256_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m256_n256_k256_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=512 N=512 K=512
extern "C" void matmul_m512_n512_k512_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m512_n512_k512_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=1024 N=1024 K=1024
extern "C" void matmul_m1024_n1024_k1024_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m1024_n1024_k1024_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=2048 N=2048 K=2048
extern "C" void matmul_m2048_n2048_k2048_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m2048_n2048_k2048_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=4096 N=4096 K=4096
extern "C" void matmul_m4096_n4096_k4096_ACC_v2_Ns_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m4096_n4096_k4096_ACC_v2_Ns_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=16 N=16 K=16
extern "C" void matmul_m16_n16_k16_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m16_n16_k16_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=32 N=32 K=32
extern "C" void matmul_m32_n32_k32_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m32_n32_k32_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=64 N=64 K=64
extern "C" void matmul_m64_n64_k64_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m64_n64_k64_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=128 N=128 K=128
extern "C" void matmul_m128_n128_k128_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m128_n128_k128_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=256 N=256 K=256
extern "C" void matmul_m256_n256_k256_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m256_n256_k256_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=512 N=512 K=512
extern "C" void matmul_m512_n512_k512_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m512_n512_k512_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=1024 N=1024 K=1024
extern "C" void matmul_m1024_n1024_k1024_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m1024_n1024_k1024_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=2048 N=2048 K=2048
extern "C" void matmul_m2048_n2048_k2048_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m2048_n2048_k2048_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=4096 N=4096 K=4096
extern "C" void matmul_m4096_n4096_k4096_ACC_v2_As_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m4096_n4096_k4096_ACC_v2_As_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=16 N=16 K=16
extern "C" void matmul_m16_n16_k16_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m16_n16_k16_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=32 N=32 K=32
extern "C" void matmul_m32_n32_k32_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m32_n32_k32_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=64 N=64 K=64
extern "C" void matmul_m64_n64_k64_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m64_n64_k64_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=128 N=128 K=128
extern "C" void matmul_m128_n128_k128_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m128_n128_k128_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=256 N=256 K=256
extern "C" void matmul_m256_n256_k256_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m256_n256_k256_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=512 N=512 K=512
extern "C" void matmul_m512_n512_k512_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m512_n512_k512_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=1024 N=1024 K=1024
extern "C" void matmul_m1024_n1024_k1024_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m1024_n1024_k1024_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=2048 N=2048 K=2048
extern "C" void matmul_m2048_n2048_k2048_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m2048_n2048_k2048_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);


// M=4096 N=4096 K=4096
extern "C" void matmul_m4096_n4096_k4096_ACC_v2_Bs_call(
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, int64_t size0_d0, int64_t size0_d1,
  int64_t stride0_d0, int64_t stride0_d1,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, int64_t size1_d0, int64_t size1_d1,
  int64_t stride1_d0, int64_t stride1_d1,
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, int64_t size2_d0, int64_t size2_d1,
  int64_t stride2_d0, int64_t stride2_d1);

extern "C" void _mlir_ciface_matmul_m4096_n4096_k4096_ACC_v2_Bs_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);

