
// M=$MVAL N=$NVAL K=$KVAL
func @matmul_m${MVAL}_n${NVAL}_k${KVAL}_${TAG}_call(
  %A: memref<${MVAL}x${KVAL}xi32>, 
  %B: memref<${KVAL}x${NVAL}xi32>, 
  %C: memref<${MVAL}x${NVAL}xi32>) {
  linalg.matmul {__internal_linalg_transform__="${TAG}"}
   ins(%A, %B: memref<${MVAL}x${KVAL}xi32>, memref<${KVAL}x${NVAL}xi32>)
   outs(%C: memref<${MVAL}x${NVAL}xi32>)
  return
}
