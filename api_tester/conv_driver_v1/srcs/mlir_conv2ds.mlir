func @conv2d_B1_IHW7_IC2_FHW3_OC2_ST2_MLIR_ACC_v3_call(
  %arg0: memref<1x2x7x7xi32>, 
  %arg1: memref<2x2x3x3xi32>, 
  %arg2: memref<1x2x3x3xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x2x7x7xi32>, memref<2x2x3x3xi32>)
    outs (%arg2: memref<1x2x3x3xi32>)
  return
}

func @conv2d_B1_IHW7_IC2_FHW3_OC2_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x2x7x7xi32>, 
  %arg1: memref<2x2x3x3xi32>, 
  %arg2: memref<1x2x3x3xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x2x7x7xi32>, memref<2x2x3x3xi32>)
    outs (%arg2: memref<1x2x3x3xi32>)
  return
}

