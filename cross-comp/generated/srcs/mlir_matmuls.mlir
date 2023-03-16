
// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v1_Ns_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v1_Ns_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v1_Ns_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v1_Ns_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=256 N=256 K=256
func @matmul_m256_n256_k256_ACC_v1_Ns_call(
  %A: memref<256x256xi32>, 
  %B: memref<256x256xi32>, 
  %C: memref<256x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<256x256xi32>, memref<256x256xi32>)
   outs(%C: memref<256x256xi32>)
  return
}


// M=512 N=512 K=512
func @matmul_m512_n512_k512_ACC_v1_Ns_call(
  %A: memref<512x512xi32>, 
  %B: memref<512x512xi32>, 
  %C: memref<512x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<512x512xi32>, memref<512x512xi32>)
   outs(%C: memref<512x512xi32>)
  return
}


// M=1024 N=1024 K=1024
func @matmul_m1024_n1024_k1024_ACC_v1_Ns_call(
  %A: memref<1024x1024xi32>, 
  %B: memref<1024x1024xi32>, 
  %C: memref<1024x1024xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<1024x1024xi32>, memref<1024x1024xi32>)
   outs(%C: memref<1024x1024xi32>)
  return
}


// M=2048 N=2048 K=2048
func @matmul_m2048_n2048_k2048_ACC_v1_Ns_call(
  %A: memref<2048x2048xi32>, 
  %B: memref<2048x2048xi32>, 
  %C: memref<2048x2048xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<2048x2048xi32>, memref<2048x2048xi32>)
   outs(%C: memref<2048x2048xi32>)
  return
}


// M=4096 N=4096 K=4096
func @matmul_m4096_n4096_k4096_ACC_v1_Ns_call(
  %A: memref<4096x4096xi32>, 
  %B: memref<4096x4096xi32>, 
  %C: memref<4096x4096xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<4096x4096xi32>, memref<4096x4096xi32>)
   outs(%C: memref<4096x4096xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v2_Ns_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v2_Ns_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v2_Ns_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v2_Ns_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=256 N=256 K=256
func @matmul_m256_n256_k256_ACC_v2_Ns_call(
  %A: memref<256x256xi32>, 
  %B: memref<256x256xi32>, 
  %C: memref<256x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<256x256xi32>, memref<256x256xi32>)
   outs(%C: memref<256x256xi32>)
  return
}


// M=512 N=512 K=512
func @matmul_m512_n512_k512_ACC_v2_Ns_call(
  %A: memref<512x512xi32>, 
  %B: memref<512x512xi32>, 
  %C: memref<512x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<512x512xi32>, memref<512x512xi32>)
   outs(%C: memref<512x512xi32>)
  return
}


// M=1024 N=1024 K=1024
func @matmul_m1024_n1024_k1024_ACC_v2_Ns_call(
  %A: memref<1024x1024xi32>, 
  %B: memref<1024x1024xi32>, 
  %C: memref<1024x1024xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<1024x1024xi32>, memref<1024x1024xi32>)
   outs(%C: memref<1024x1024xi32>)
  return
}


// M=2048 N=2048 K=2048
func @matmul_m2048_n2048_k2048_ACC_v2_Ns_call(
  %A: memref<2048x2048xi32>, 
  %B: memref<2048x2048xi32>, 
  %C: memref<2048x2048xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<2048x2048xi32>, memref<2048x2048xi32>)
   outs(%C: memref<2048x2048xi32>)
  return
}


// M=4096 N=4096 K=4096
func @matmul_m4096_n4096_k4096_ACC_v2_Ns_call(
  %A: memref<4096x4096xi32>, 
  %B: memref<4096x4096xi32>, 
  %C: memref<4096x4096xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<4096x4096xi32>, memref<4096x4096xi32>)
   outs(%C: memref<4096x4096xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v2_As_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v2_As_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v2_As_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v2_As_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=256 N=256 K=256
func @matmul_m256_n256_k256_ACC_v2_As_call(
  %A: memref<256x256xi32>, 
  %B: memref<256x256xi32>, 
  %C: memref<256x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<256x256xi32>, memref<256x256xi32>)
   outs(%C: memref<256x256xi32>)
  return
}


// M=512 N=512 K=512
func @matmul_m512_n512_k512_ACC_v2_As_call(
  %A: memref<512x512xi32>, 
  %B: memref<512x512xi32>, 
  %C: memref<512x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<512x512xi32>, memref<512x512xi32>)
   outs(%C: memref<512x512xi32>)
  return
}


// M=1024 N=1024 K=1024
func @matmul_m1024_n1024_k1024_ACC_v2_As_call(
  %A: memref<1024x1024xi32>, 
  %B: memref<1024x1024xi32>, 
  %C: memref<1024x1024xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<1024x1024xi32>, memref<1024x1024xi32>)
   outs(%C: memref<1024x1024xi32>)
  return
}


// M=2048 N=2048 K=2048
func @matmul_m2048_n2048_k2048_ACC_v2_As_call(
  %A: memref<2048x2048xi32>, 
  %B: memref<2048x2048xi32>, 
  %C: memref<2048x2048xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<2048x2048xi32>, memref<2048x2048xi32>)
   outs(%C: memref<2048x2048xi32>)
  return
}


// M=4096 N=4096 K=4096
func @matmul_m4096_n4096_k4096_ACC_v2_As_call(
  %A: memref<4096x4096xi32>, 
  %B: memref<4096x4096xi32>, 
  %C: memref<4096x4096xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<4096x4096xi32>, memref<4096x4096xi32>)
   outs(%C: memref<4096x4096xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v2_Bs_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v2_Bs_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v2_Bs_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v2_Bs_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=256 N=256 K=256
func @matmul_m256_n256_k256_ACC_v2_Bs_call(
  %A: memref<256x256xi32>, 
  %B: memref<256x256xi32>, 
  %C: memref<256x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<256x256xi32>, memref<256x256xi32>)
   outs(%C: memref<256x256xi32>)
  return
}


// M=512 N=512 K=512
func @matmul_m512_n512_k512_ACC_v2_Bs_call(
  %A: memref<512x512xi32>, 
  %B: memref<512x512xi32>, 
  %C: memref<512x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<512x512xi32>, memref<512x512xi32>)
   outs(%C: memref<512x512xi32>)
  return
}


// M=1024 N=1024 K=1024
func @matmul_m1024_n1024_k1024_ACC_v2_Bs_call(
  %A: memref<1024x1024xi32>, 
  %B: memref<1024x1024xi32>, 
  %C: memref<1024x1024xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<1024x1024xi32>, memref<1024x1024xi32>)
   outs(%C: memref<1024x1024xi32>)
  return
}


// M=2048 N=2048 K=2048
func @matmul_m2048_n2048_k2048_ACC_v2_Bs_call(
  %A: memref<2048x2048xi32>, 
  %B: memref<2048x2048xi32>, 
  %C: memref<2048x2048xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<2048x2048xi32>, memref<2048x2048xi32>)
   outs(%C: memref<2048x2048xi32>)
  return
}


// M=4096 N=4096 K=4096
func @matmul_m4096_n4096_k4096_ACC_v2_Bs_call(
  %A: memref<4096x4096xi32>, 
  %B: memref<4096x4096xi32>, 
  %C: memref<4096x4096xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<4096x4096xi32>, memref<4096x4096xi32>)
   outs(%C: memref<4096x4096xi32>)
  return
}

