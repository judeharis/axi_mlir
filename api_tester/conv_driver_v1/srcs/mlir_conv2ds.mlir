func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x230x230x3xf32>, 
  %arg1: memref<7x7x3x64xf32>, 
  %arg2: memref<1x112x112x64xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x230x230x3xf32>, memref<7x7x3x64xf32>)
    outs (%arg2: memref<1x112x112x64xf32>)
  return
}

func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call(
  %arg0: memref<1x230x230x3xf32>, 
  %arg1: memref<7x7x3x64xf32>, 
  %arg2: memref<1x112x112x64xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x230x230x3xf32>, memref<7x7x3x64xf32>)
    outs (%arg2: memref<1x112x112x64xf32>)
  return
}

func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x7x7x8xf32>,
  %arg1: memref<3x3x8x2xf32>,
  %arg2: memref<1x5x5x2xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xf32>, memref<3x3x8x2xf32>)
    outs (%arg2: memref<1x5x5x2xf32>)
  return
}

func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST1_MLIR_ACC_v3_call(
  %arg0: memref<1x7x7x8xf32>,
  %arg1: memref<3x3x8x2xf32>,
  %arg2: memref<1x5x5x2xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xf32>, memref<3x3x8x2xf32>)
    outs (%arg2: memref<1x5x5x2xf32>)
  return
}


// TODO double check that dividing st2 output is correct
func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x7x7x8xf32>,
  %arg1: memref<3x3x8x2xf32>,
  %arg2: memref<1x3x3x2xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xf32>, memref<3x3x8x2xf32>)
    outs (%arg2: memref<1x3x3x2xf32>)
  return
}

// TODO double check that dividing st2 output is correct
func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST2_MLIR_ACC_v3_call(
  %arg0: memref<1x7x7x8xf32>,
  %arg1: memref<3x3x8x2xf32>,
  %arg2: memref<1x3x3x2xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xf32>, memref<3x3x8x2xf32>)
    outs (%arg2: memref<1x3x3x2xf32>)
  return
}