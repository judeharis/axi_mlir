
// M=512 N=1024 K=64
func @matmul_m512_n1024_k64_ACC_v4_As_64_64_64_0_call(
  %A: memref<512x64xi32>, 
  %B: memref<64x1024xi32>, 
  %C: memref<512x1024xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_64_64_64_0"}
   ins(%A, %B: memref<512x64xi32>, memref<64x1024xi32>)
   outs(%C: memref<512x1024xi32>)
  return
}


// M=64 N=512 K=512
func @matmul_m64_n512_k512_ACC_v4_Cs_64_64_64_1_call(
  %A: memref<64x512xi32>, 
  %B: memref<512x512xi32>, 
  %C: memref<64x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_1"}
   ins(%A, %B: memref<64x512xi32>, memref<512x512xi32>)
   outs(%C: memref<64x512xi32>)
  return
}


// M=512 N=256 K=16
func @matmul_m512_n256_k16_ACC_v4_Bs_16_256_16_2_call(
  %A: memref<512x16xi32>, 
  %B: memref<16x256xi32>, 
  %C: memref<512x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_16_256_16_2"}
   ins(%A, %B: memref<512x16xi32>, memref<16x256xi32>)
   outs(%C: memref<512x256xi32>)
  return
}


// M=32 N=256 K=1024
func @matmul_m32_n256_k1024_ACC_v4_Cs_32_128_32_3_call(
  %A: memref<32x1024xi32>, 
  %B: memref<1024x256xi32>, 
  %C: memref<32x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_128_32_3"}
   ins(%A, %B: memref<32x1024xi32>, memref<1024x256xi32>)
   outs(%C: memref<32x256xi32>)
  return
}

