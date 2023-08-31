
// CPU
extern "C" void conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_CPU_call(
  // First Memref (%arg0)
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, 
  int64_t size0_d0, int64_t size0_d1,
  int64_t size0_d2, int64_t size0_d3,
  int64_t stride0_d0, int64_t stride0_d1,
  int64_t stride0_d2, int64_t stride0_d3,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, 
  int64_t size1_d0, int64_t size1_d1,
  int64_t size1_d2, int64_t size1_d3,
  int64_t stride1_d0, int64_t stride1_d1,
  int64_t stride1_d2, int64_t stride1_d3,
  // Third Memref (%arg2)
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, 
  int64_t size2_d0, int64_t size2_d1,
  int64_t size2_d2, int64_t size2_d3,
  int64_t stride2_d0, int64_t stride2_d1,
  int64_t stride2_d2, int64_t stride2_d3
  );

extern "C" void _mlir_ciface_conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_CPU_call(
  memref_4d_descriptor *arg0,
  memref_4d_descriptor *arg1,
  memref_4d_descriptor *arg2);

// TODO: ACCEL
extern "C" void B1_IHW230_IC3_FHW7_OC64_ST2_ACC_v3_Fs_call(
  // First Memref (%arg0)
  int *allocated_ptr0, int *aligned_ptr0,
  int64_t offset0, 
  int64_t size0_d0, int64_t size0_d1,
  int64_t size0_d2, int64_t size0_d3,
  int64_t stride0_d0, int64_t stride0_d1,
  int64_t stride0_d2, int64_t stride0_d3,
  // Second Memref (%arg1)
  int *allocated_ptr1, int *aligned_ptr1,
  int64_t offset1, 
  int64_t size1_d0, int64_t size1_d1,
  int64_t size1_d2, int64_t size1_d3,
  int64_t stride1_d0, int64_t stride1_d1,
  int64_t stride1_d2, int64_t stride1_d3,
  // Third Memref (%arg2)
  int *allocated_ptr2, int *aligned_ptr2,
  int64_t offset2, 
  int64_t size2_d0, int64_t size2_d1,
  int64_t size2_d2, int64_t size2_d3,
  int64_t stride2_d0, int64_t stride2_d1,
  int64_t stride2_d2, int64_t stride2_d3
  );

extern "C" void _mlir_ciface_B1_IHW230_IC3_FHW7_OC64_ST2_ACC_v3_Fs_call(
  memref_4d_descriptor *arg0,
  memref_4d_descriptor *arg1,
  memref_4d_descriptor *arg2);
