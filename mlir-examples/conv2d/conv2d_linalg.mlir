// CHECK-LABEL: @conv2d_padded_i32
func @conv2d_padded_i32(%input: memref<1x49x42x28xi32>, %weights: memref<3x3x28x28xi32>, %out: memref<1x45x40x28xi32>) -> () {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<[2, 1]> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%input, %weights : memref<1x49x42x28xi32>, memref<3x3x28x28xi32>) outs(%out : memref<1x45x40x28xi32>)
  return
}


func @conv_2d_nhwc_hwcf(%arg0: memref<1x8x8x28xf32>, %arg1: memref<3x3x28x16xf32>, %arg2: memref<1x5x5x16xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                          strides = dense<1> : tensor<2xi64>}
     ins (%arg0, %arg1: memref<1x8x8x28xf32>, memref<3x3x28x16xf32>)
    outs (%arg2: memref<1x5x5x16xf32>)
  return
}