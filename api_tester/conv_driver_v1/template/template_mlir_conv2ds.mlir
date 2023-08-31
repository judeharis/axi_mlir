func @${MLIR_CALL}(
  %arg0: memref<${B}x${IC}x${IHW}x${IHW}xi32>, 
  %arg1: memref<${OC}x${IC}x${FHW}x${FHW}xi32>, 
  %arg2: memref<${B}x${OC}x${OHW}x${OHW}xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<${ST}> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<${B}x${IC}x${IHW}x${IHW}xi32>, memref<${OC}x${IC}x${FHW}x${FHW}xi32>)
    outs (%arg2: memref<${B}x${OC}x${OHW}x${OHW}xi32>)
  return
}
