
// M=$MVAL N=$NVAL K=$KVAL
extern "C" void matmul_m${MVAL}_n${NVAL}_k${KVAL}_${TAG}_call(
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

extern "C" void _mlir_ciface_matmul_m${MVAL}_n${NVAL}_k${KVAL}_${TAG}_call(
  memref_2d_descriptor *arg0,
  memref_2d_descriptor *arg1,
  memref_2d_descriptor *arg2);
