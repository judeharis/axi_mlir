func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_CPU_call(
  %arg0: memref<1x230x230x3xf32>, 
  %arg1: memref<7x7x3x64xf32>, 
  %arg2: memref<1x112x112x64xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x230x230x3xf32>, memref<7x7x3x64xf32>)
    outs (%arg2: memref<1x112x112x64xf32>)
  return
}

func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_ACC_v3_Fs_call(
  %arg0: memref<1x230x230x3xf32>, 
  %arg1: memref<7x7x3x64xf32>, 
  %arg2: memref<1x112x112x64xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x230x230x3xf32>, memref<7x7x3x64xf32>)
    outs (%arg2: memref<1x112x112x64xf32>)
  return
}