
// M=4 N=4 K=4
func @matmul_m4_n4_k4_v1_Ns_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__internal_linalg_transform__="v1_Ns"}
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_v1_Ns_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__internal_linalg_transform__="v1_Ns"}
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
  return
}


// M=16 N=16 K=16
func @matmul_m16_n16_k16_v1_Ns_call(
  %A: memref<16x16xi32>, 
  %B: memref<16x16xi32>, 
  %C: memref<16x16xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__internal_linalg_transform__="v1_Ns"}
   ins(%A, %B: memref<16x16xi32>, memref<16x16xi32>)
   outs(%C: memref<16x16xi32>)
  return
}


// M=32 N=32 K=32
func @matmul_m32_n32_k32_v1_Ns_call(
  %A: memref<32x32xi32>, 
  %B: memref<32x32xi32>, 
  %C: memref<32x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__internal_linalg_transform__="v1_Ns"}
   ins(%A, %B: memref<32x32xi32>, memref<32x32xi32>)
   outs(%C: memref<32x32xi32>)
  return
}


// M=64 N=64 K=64
func @matmul_m64_n64_k64_v1_Ns_call(
  %A: memref<64x64xi32>, 
  %B: memref<64x64xi32>, 
  %C: memref<64x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__internal_linalg_transform__="v1_Ns"}
   ins(%A, %B: memref<64x64xi32>, memref<64x64xi32>)
   outs(%C: memref<64x64xi32>)
  return
}

