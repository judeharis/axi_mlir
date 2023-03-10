
// M=4 N=4 K=4
func @matmul_m4_n4_k4_L1_call(
  %A: memref<4x4xi32>, 
  %B: memref<4x4xi32>, 
  %C: memref<4x4xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul 
   ins(%A, %B: memref<4x4xi32>, memref<4x4xi32>)
   outs(%C: memref<4x4xi32>)
  return
}


// M=8 N=8 K=8
func @matmul_m8_n8_k8_L1_call(
  %A: memref<8x8xi32>, 
  %B: memref<8x8xi32>, 
  %C: memref<8x8xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul 
   ins(%A, %B: memref<8x8xi32>, memref<8x8xi32>)
   outs(%C: memref<8x8xi32>)
  return
}

