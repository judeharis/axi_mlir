// CHECK-LABEL: @conv2d_padded_f32
func @conv2d_padded_f32(%input: tensor<1x47x40x28xf32>, %weights: tensor<28x3x3x28xf32>, %bias: tensor<28xf32>) -> (tensor<1x45x40x28xf32>) {
  // CHECK: %[[C0:.+]] = arith.constant 0
  // CHECK: tensor.pad %arg0 low[0, 1, 1, 0] high[0, 1, 1, 0]
  // CHECK:   tensor.yield %[[C0]]
  // CHECK: linalg.conv_2d_nhwc_hwcf
  %0 = "tosa.conv2d"(%input, %weights, %bias) {pad = [1, 1, 1, 1], stride = [1, 1], dilation = [2, 1]} : (tensor<1x47x40x28xf32>, tensor<28x3x3x28xf32>, tensor<28xf32>)  -> (tensor<1x45x40x28xf32>)
  return %0 : tensor<1x45x40x28xf32>
}