
// M=64 N=512 K=512
func @matmul_m64_n512_k512_ACC_v4_As_64_64_64_0_call(
  %A: memref<64x512xi32>, 
  %B: memref<512x512xi32>, 
  %C: memref<64x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_64_64_64_0"}
   ins(%A, %B: memref<64x512xi32>, memref<512x512xi32>)
   outs(%C: memref<64x512xi32>)
  return
}

