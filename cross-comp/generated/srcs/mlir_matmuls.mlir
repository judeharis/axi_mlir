
// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v1_Ns_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v1_Ns_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v1_Ns"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
  return
}


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


// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v2_Ns_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v2_Ns_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Ns"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
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


// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v2_As_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v2_As_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_As"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
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


// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v2_Bs_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v2_Bs_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v2_Bs"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
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


// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v3_Ns_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Ns"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v3_Ns_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Ns"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v3_Ns_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Ns"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v3_Ns_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Ns"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v3_Ns_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Ns"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v3_Ns_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Ns"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v3_As_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_As"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v3_As_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_As"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v3_As_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_As"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v3_As_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_As"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v3_As_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_As"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v3_As_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_As"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v3_Bs_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Bs"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v3_Bs_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Bs"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v3_Bs_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Bs"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v3_Bs_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Bs"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v3_Bs_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Bs"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v3_Bs_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Bs"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=4 N=4 K=4
func @matmul_m4_n4_k4_ACC_v3_Cs_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Cs"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_ACC_v3_Cs_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Cs"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_ACC_v3_Cs_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Cs"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_ACC_v3_Cs_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Cs"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_ACC_v3_Cs_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Cs"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v3_Cs_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v3_Cs"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}

