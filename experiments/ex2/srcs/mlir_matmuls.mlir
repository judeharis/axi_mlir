
// M=32 N=256 K=512
func @matmul_m32_n256_k512_ACC_v4_As_32_32_32_0_AsquareTile_call(
  %A: memref<32x512xi32>, 
  %B: memref<512x256xi32>, 
  %C: memref<32x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_32_32_32_0_AsquareTile"}
   ins(%A, %B: memref<32x512xi32>, memref<512x256xi32>)
   outs(%C: memref<32x256xi32>)
  return
}


// M=32 N=256 K=512
func @matmul_m32_n256_k512_ACC_v4_Bs_32_32_32_0_BsquareTile_call(
  %A: memref<32x512xi32>, 
  %B: memref<512x256xi32>, 
  %C: memref<32x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_32_32_32_0_BsquareTile"}
   ins(%A, %B: memref<32x512xi32>, memref<512x256xi32>)
   outs(%C: memref<32x256xi32>)
  return
}


// M=32 N=256 K=512
func @matmul_m32_n256_k512_ACC_v4_Cs_32_32_32_0_CsquareTiles_call(
  %A: memref<32x512xi32>, 
  %B: memref<512x256xi32>, 
  %C: memref<32x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_32_32_0_CsquareTiles"}
   ins(%A, %B: memref<32x512xi32>, memref<512x256xi32>)
   outs(%C: memref<32x256xi32>)
  return
}


// M=32 N=256 K=512
func @matmul_m32_n256_k512_ACC_v4_Cs_32_128_32_0_Optimal_call(
  %A: memref<32x512xi32>, 
  %B: memref<512x256xi32>, 
  %C: memref<32x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_128_32_0_Optimal"}
   ins(%A, %B: memref<32x512xi32>, memref<512x256xi32>)
   outs(%C: memref<32x256xi32>)
  return
}


// M=32 N=512 K=256
func @matmul_m32_n512_k256_ACC_v4_As_32_32_32_1_AsquareTile_call(
  %A: memref<32x256xi32>, 
  %B: memref<256x512xi32>, 
  %C: memref<32x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_32_32_32_1_AsquareTile"}
   ins(%A, %B: memref<32x256xi32>, memref<256x512xi32>)
   outs(%C: memref<32x512xi32>)
  return
}


// M=32 N=512 K=256
func @matmul_m32_n512_k256_ACC_v4_Bs_32_32_32_1_BsquareTile_call(
  %A: memref<32x256xi32>, 
  %B: memref<256x512xi32>, 
  %C: memref<32x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_32_32_32_1_BsquareTile"}
   ins(%A, %B: memref<32x256xi32>, memref<256x512xi32>)
   outs(%C: memref<32x512xi32>)
  return
}


// M=32 N=512 K=256
func @matmul_m32_n512_k256_ACC_v4_Cs_32_32_32_1_CsquareTiles_call(
  %A: memref<32x256xi32>, 
  %B: memref<256x512xi32>, 
  %C: memref<32x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_32_32_1_CsquareTiles"}
   ins(%A, %B: memref<32x256xi32>, memref<256x512xi32>)
   outs(%C: memref<32x512xi32>)
  return
}


// M=32 N=512 K=256
func @matmul_m32_n512_k256_ACC_v4_Cs_32_128_32_1_Optimal_call(
  %A: memref<32x256xi32>, 
  %B: memref<256x512xi32>, 
  %C: memref<32x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_128_32_1_Optimal"}
   ins(%A, %B: memref<32x256xi32>, memref<256x512xi32>)
   outs(%C: memref<32x512xi32>)
  return
}


// M=256 N=32 K=512
func @matmul_m256_n32_k512_ACC_v4_As_32_32_32_2_AsquareTile_call(
  %A: memref<256x512xi32>, 
  %B: memref<512x32xi32>, 
  %C: memref<256x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_32_32_32_2_AsquareTile"}
   ins(%A, %B: memref<256x512xi32>, memref<512x32xi32>)
   outs(%C: memref<256x32xi32>)
  return
}


// M=256 N=32 K=512
func @matmul_m256_n32_k512_ACC_v4_Bs_32_32_32_2_BsquareTile_call(
  %A: memref<256x512xi32>, 
  %B: memref<512x32xi32>, 
  %C: memref<256x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_32_32_32_2_BsquareTile"}
   ins(%A, %B: memref<256x512xi32>, memref<512x32xi32>)
   outs(%C: memref<256x32xi32>)
  return
}


// M=256 N=32 K=512
func @matmul_m256_n32_k512_ACC_v4_Cs_32_32_32_2_CsquareTiles_call(
  %A: memref<256x512xi32>, 
  %B: memref<512x32xi32>, 
  %C: memref<256x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_32_32_2_CsquareTiles"}
   ins(%A, %B: memref<256x512xi32>, memref<512x32xi32>)
   outs(%C: memref<256x32xi32>)
  return
}


// M=256 N=32 K=512
func @matmul_m256_n32_k512_ACC_v4_Cs_128_32_32_2_Optimal_call(
  %A: memref<256x512xi32>, 
  %B: memref<512x32xi32>, 
  %C: memref<256x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_128_32_32_2_Optimal"}
   ins(%A, %B: memref<256x512xi32>, memref<512x32xi32>)
   outs(%C: memref<256x32xi32>)
  return
}


// M=256 N=512 K=32
func @matmul_m256_n512_k32_ACC_v4_As_32_32_32_3_AsquareTile_call(
  %A: memref<256x32xi32>, 
  %B: memref<32x512xi32>, 
  %C: memref<256x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_32_32_32_3_AsquareTile"}
   ins(%A, %B: memref<256x32xi32>, memref<32x512xi32>)
   outs(%C: memref<256x512xi32>)
  return
}


// M=256 N=512 K=32
func @matmul_m256_n512_k32_ACC_v4_Bs_32_32_32_3_BsquareTile_call(
  %A: memref<256x32xi32>, 
  %B: memref<32x512xi32>, 
  %C: memref<256x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_32_32_32_3_BsquareTile"}
   ins(%A, %B: memref<256x32xi32>, memref<32x512xi32>)
   outs(%C: memref<256x512xi32>)
  return
}


// M=256 N=512 K=32
func @matmul_m256_n512_k32_ACC_v4_Cs_32_32_32_3_CsquareTiles_call(
  %A: memref<256x32xi32>, 
  %B: memref<32x512xi32>, 
  %C: memref<256x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_32_32_3_CsquareTiles"}
   ins(%A, %B: memref<256x32xi32>, memref<32x512xi32>)
   outs(%C: memref<256x512xi32>)
  return
}


// M=256 N=512 K=32
func @matmul_m256_n512_k32_ACC_v4_As_128_32_32_3_Optimal_call(
  %A: memref<256x32xi32>, 
  %B: memref<32x512xi32>, 
  %C: memref<256x512xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_128_32_32_3_Optimal"}
   ins(%A, %B: memref<256x32xi32>, memref<32x512xi32>)
   outs(%C: memref<256x512xi32>)
  return
}


// M=512 N=32 K=256
func @matmul_m512_n32_k256_ACC_v4_As_32_32_32_4_AsquareTile_call(
  %A: memref<512x256xi32>, 
  %B: memref<256x32xi32>, 
  %C: memref<512x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_32_32_32_4_AsquareTile"}
   ins(%A, %B: memref<512x256xi32>, memref<256x32xi32>)
   outs(%C: memref<512x32xi32>)
  return
}


// M=512 N=32 K=256
func @matmul_m512_n32_k256_ACC_v4_Bs_32_32_32_4_BsquareTile_call(
  %A: memref<512x256xi32>, 
  %B: memref<256x32xi32>, 
  %C: memref<512x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_32_32_32_4_BsquareTile"}
   ins(%A, %B: memref<512x256xi32>, memref<256x32xi32>)
   outs(%C: memref<512x32xi32>)
  return
}


// M=512 N=32 K=256
func @matmul_m512_n32_k256_ACC_v4_Cs_32_32_32_4_CsquareTiles_call(
  %A: memref<512x256xi32>, 
  %B: memref<256x32xi32>, 
  %C: memref<512x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_32_32_4_CsquareTiles"}
   ins(%A, %B: memref<512x256xi32>, memref<256x32xi32>)
   outs(%C: memref<512x32xi32>)
  return
}


// M=512 N=32 K=256
func @matmul_m512_n32_k256_ACC_v4_Cs_128_32_32_4_Optimal_call(
  %A: memref<512x256xi32>, 
  %B: memref<256x32xi32>, 
  %C: memref<512x32xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_128_32_32_4_Optimal"}
   ins(%A, %B: memref<512x256xi32>, memref<256x32xi32>)
   outs(%C: memref<512x32xi32>)
  return
}


// M=512 N=256 K=32
func @matmul_m512_n256_k32_ACC_v4_As_32_32_32_5_AsquareTile_call(
  %A: memref<512x32xi32>, 
  %B: memref<32x256xi32>, 
  %C: memref<512x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_As_32_32_32_5_AsquareTile"}
   ins(%A, %B: memref<512x32xi32>, memref<32x256xi32>)
   outs(%C: memref<512x256xi32>)
  return
}


// M=512 N=256 K=32
func @matmul_m512_n256_k32_ACC_v4_Bs_32_32_32_5_BsquareTile_call(
  %A: memref<512x32xi32>, 
  %B: memref<32x256xi32>, 
  %C: memref<512x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_32_32_32_5_BsquareTile"}
   ins(%A, %B: memref<512x32xi32>, memref<32x256xi32>)
   outs(%C: memref<512x256xi32>)
  return
}


// M=512 N=256 K=32
func @matmul_m512_n256_k32_ACC_v4_Cs_32_32_32_5_CsquareTiles_call(
  %A: memref<512x32xi32>, 
  %B: memref<32x256xi32>, 
  %C: memref<512x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Cs_32_32_32_5_CsquareTiles"}
   ins(%A, %B: memref<512x32xi32>, memref<32x256xi32>)
   outs(%C: memref<512x256xi32>)
  return
}


// M=512 N=256 K=32
func @matmul_m512_n256_k32_ACC_v4_Bs_32_128_32_5_Optimal_call(
  %A: memref<512x32xi32>, 
  %B: memref<32x256xi32>, 
  %C: memref<512x256xi32>) 
  attributes {llvm.emit_c_interface} 
{
  linalg.matmul {__accel_transform__="ACC_v4_Bs_32_128_32_5_Optimal"}
   ins(%A, %B: memref<512x32xi32>, memref<32x256xi32>)
   outs(%C: memref<512x256xi32>)
  return
}

