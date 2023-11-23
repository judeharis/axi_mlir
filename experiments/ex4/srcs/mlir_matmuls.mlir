
// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v4_Ns_64_64_64_0_NsquareTile_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Ns_64_64_64_0_NsquareTile"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v4_Cs_64_64_64_0_CsquareTiles_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_0_CsquareTiles"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v4_Cs_64_64_64_0_Best_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_0_Best"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=128
func @matmul_m128_n128_k128_ACC_v4_Cs_64_64_64_0_CPU_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_0_CPU"}
   ins(%A, %B: memref<128x128xi32>, memref<128x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=64
func @matmul_m128_n128_k64_ACC_v4_Ns_64_64_64_1_NsquareTile_call(
  %A: memref<128x64xi32>, 
  %B: memref<64x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Ns_64_64_64_1_NsquareTile"}
   ins(%A, %B: memref<128x64xi32>, memref<64x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=64
func @matmul_m128_n128_k64_ACC_v4_Cs_64_64_64_1_CsquareTiles_call(
  %A: memref<128x64xi32>, 
  %B: memref<64x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_1_CsquareTiles"}
   ins(%A, %B: memref<128x64xi32>, memref<64x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=64
func @matmul_m128_n128_k64_ACC_v4_As_64_64_64_1_Best_call(
  %A: memref<128x64xi32>, 
  %B: memref<64x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_64_64_64_1_Best"}
   ins(%A, %B: memref<128x64xi32>, memref<64x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=64
func @matmul_m128_n128_k64_ACC_v4_As_64_64_64_1_CPU_call(
  %A: memref<128x64xi32>, 
  %B: memref<64x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_64_64_64_1_CPU"}
   ins(%A, %B: memref<128x64xi32>, memref<64x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=64 K=128
func @matmul_m128_n64_k128_ACC_v4_Ns_64_64_64_2_NsquareTile_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x64xi32>, 
  %C: memref<128x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Ns_64_64_64_2_NsquareTile"}
   ins(%A, %B: memref<128x128xi32>, memref<128x64xi32>)
   outs(%C: memref<128x64xi32>)
  return
}


// M=128 N=64 K=128
func @matmul_m128_n64_k128_ACC_v4_Cs_64_64_64_2_CsquareTiles_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x64xi32>, 
  %C: memref<128x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_2_CsquareTiles"}
   ins(%A, %B: memref<128x128xi32>, memref<128x64xi32>)
   outs(%C: memref<128x64xi32>)
  return
}


// M=128 N=64 K=128
func @matmul_m128_n64_k128_ACC_v4_Cs_64_64_64_2_Best_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x64xi32>, 
  %C: memref<128x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_2_Best"}
   ins(%A, %B: memref<128x128xi32>, memref<128x64xi32>)
   outs(%C: memref<128x64xi32>)
  return
}


// M=128 N=64 K=128
func @matmul_m128_n64_k128_ACC_v4_Cs_64_64_64_2_CPU_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x64xi32>, 
  %C: memref<128x64xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_2_CPU"}
   ins(%A, %B: memref<128x128xi32>, memref<128x64xi32>)
   outs(%C: memref<128x64xi32>)
  return
}


// M=128 N=512 K=128
func @matmul_m128_n512_k128_ACC_v4_Ns_64_64_64_3_NsquareTile_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x512xi32>, 
  %C: memref<128x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Ns_64_64_64_3_NsquareTile"}
   ins(%A, %B: memref<128x128xi32>, memref<128x512xi32>)
   outs(%C: memref<128x512xi32>)
  return
}


// M=128 N=512 K=128
func @matmul_m128_n512_k128_ACC_v4_Cs_64_64_64_3_CsquareTiles_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x512xi32>, 
  %C: memref<128x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_3_CsquareTiles"}
   ins(%A, %B: memref<128x128xi32>, memref<128x512xi32>)
   outs(%C: memref<128x512xi32>)
  return
}


// M=128 N=512 K=128
func @matmul_m128_n512_k128_ACC_v4_Cs_64_64_64_3_Best_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x512xi32>, 
  %C: memref<128x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_3_Best"}
   ins(%A, %B: memref<128x128xi32>, memref<128x512xi32>)
   outs(%C: memref<128x512xi32>)
  return
}


// M=128 N=512 K=128
func @matmul_m128_n512_k128_ACC_v4_Cs_64_64_64_3_CPU_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x512xi32>, 
  %C: memref<128x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_3_CPU"}
   ins(%A, %B: memref<128x128xi32>, memref<128x512xi32>)
   outs(%C: memref<128x512xi32>)
  return
}


// M=128 N=128 K=512
func @matmul_m128_n128_k512_ACC_v4_Ns_64_64_64_4_NsquareTile_call(
  %A: memref<128x512xi32>, 
  %B: memref<512x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Ns_64_64_64_4_NsquareTile"}
   ins(%A, %B: memref<128x512xi32>, memref<512x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=512
func @matmul_m128_n128_k512_ACC_v4_Cs_64_64_64_4_CsquareTiles_call(
  %A: memref<128x512xi32>, 
  %B: memref<512x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_4_CsquareTiles"}
   ins(%A, %B: memref<128x512xi32>, memref<512x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=512
func @matmul_m128_n128_k512_ACC_v4_Cs_64_64_64_4_Best_call(
  %A: memref<128x512xi32>, 
  %B: memref<512x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_4_Best"}
   ins(%A, %B: memref<128x512xi32>, memref<512x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=128 K=512
func @matmul_m128_n128_k512_ACC_v4_Cs_64_64_64_4_CPU_call(
  %A: memref<128x512xi32>, 
  %B: memref<512x128xi32>, 
  %C: memref<128x128xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_4_CPU"}
   ins(%A, %B: memref<128x512xi32>, memref<512x128xi32>)
   outs(%C: memref<128x128xi32>)
  return
}


// M=128 N=30528 K=128
func @matmul_m128_n30528_k128_ACC_v4_Ns_64_64_64_5_NsquareTile_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x30528xi32>, 
  %C: memref<128x30528xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Ns_64_64_64_5_NsquareTile"}
   ins(%A, %B: memref<128x128xi32>, memref<128x30528xi32>)
   outs(%C: memref<128x30528xi32>)
  return
}


// M=128 N=30528 K=128
func @matmul_m128_n30528_k128_ACC_v4_Cs_64_64_64_5_CsquareTiles_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x30528xi32>, 
  %C: memref<128x30528xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_5_CsquareTiles"}
   ins(%A, %B: memref<128x128xi32>, memref<128x30528xi32>)
   outs(%C: memref<128x30528xi32>)
  return
}


// M=128 N=30528 K=128
func @matmul_m128_n30528_k128_ACC_v4_Cs_64_64_64_5_Best_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x30528xi32>, 
  %C: memref<128x30528xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_5_Best"}
   ins(%A, %B: memref<128x128xi32>, memref<128x30528xi32>)
   outs(%C: memref<128x30528xi32>)
  return
}


// M=128 N=30528 K=128
func @matmul_m128_n30528_k128_ACC_v4_Cs_64_64_64_5_CPU_call(
  %A: memref<128x128xi32>, 
  %B: memref<128x30528xi32>, 
  %C: memref<128x30528xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_64_64_64_5_CPU"}
   ins(%A, %B: memref<128x128xi32>, memref<128x30528xi32>)
   outs(%C: memref<128x30528xi32>)
  return
}

