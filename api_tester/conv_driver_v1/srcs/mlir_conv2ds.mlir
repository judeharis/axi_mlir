func private @print_memref_i32(memref<*xi32>)

func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x230x230x3xi32>, 
  %arg1: memref<7x7x3x64xi32>, 
  %arg2: memref<1x112x112x64xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x230x230x3xi32>, memref<7x7x3x64xi32>)
    outs (%arg2: memref<1x112x112x64xi32>)
  return
}

func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call(
  %arg0: memref<1x230x230x3xi32>, 
  %arg1: memref<7x7x3x64xi32>, 
  %arg2: memref<1x112x112x64xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x230x230x3xi32>, memref<7x7x3x64xi32>)
    outs (%arg2: memref<1x112x112x64xi32>)
  return
}

func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x7x7x8xi32>,
  %arg1: memref<3x3x8x2xi32>,
  %arg2: memref<1x5x5x2xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xi32>, memref<3x3x8x2xi32>)
    outs (%arg2: memref<1x5x5x2xi32>)
  return
}

func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST1_MLIR_ACC_v3_call(
  %arg0: memref<1x7x7x8xi32>,
  %arg1: memref<3x3x8x2xi32>,
  %arg2: memref<1x5x5x2xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xi32>, memref<3x3x8x2xi32>)
    outs (%arg2: memref<1x5x5x2xi32>)
  return
}


// TODO double check that dividing st2 output is correct
func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x7x7x8xi32>,
  %arg1: memref<3x3x8x2xi32>,
  %arg2: memref<1x3x3x2xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xi32>, memref<3x3x8x2xi32>)
    outs (%arg2: memref<1x3x3x2xi32>)
  return
}

// TODO double check that dividing st2 output is correct
func @conv2d_B1_IHW7_IC8_FHW3_OC2_ST2_MLIR_ACC_v3_call(
  %arg0: memref<1x7x7x8xi32>,
  %arg1: memref<3x3x8x2xi32>,
  %arg2: memref<1x3x3x2xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x8xi32>, memref<3x3x8x2xi32>)
    outs (%arg2: memref<1x3x3x2xi32>)
  return
}


func @conv2d_B1_IHW7_IC1_FHW3_OC2_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x7x7x1xi32>,
  %arg1: memref<3x3x1x2xi32>,
  %arg2: memref<1x5x5x2xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x1xi32>, memref<3x3x1x2xi32>)
    outs (%arg2: memref<1x5x5x2xi32>)
  return
}

func @conv2d_B1_IHW7_IC1_FHW3_OC2_ST1_MLIR_ACC_v3_call(
  %arg0: memref<1x7x7x1xi32>,
  %arg1: memref<3x3x1x2xi32>,
  %arg2: memref<1x5x5x2xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x1xi32>, memref<3x3x1x2xi32>)
    outs (%arg2: memref<1x5x5x2xi32>)
  return
}

func @conv2d_B1_IHW7_IC2_FHW3_OC2_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x7x7x1xi32>,
  %arg1: memref<3x3x1x2xi32>,
  %arg2: memref<1x5x5x2xi32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x7x7x1xi32>, memref<3x3x1x2xi32>)
    outs (%arg2: memref<1x5x5x2xi32>)

  %in0 = memref.cast %arg0: memref<1x7x7x1xi32> to memref<*xi32>
  call @print_memref_i32(%in0) : (memref<*xi32>) -> ()
  
  %in1 = memref.cast %arg1: memref<3x3x1x2xi32> to memref<*xi32>
  call @print_memref_i32(%in1) : (memref<*xi32>) -> ()
  
  %in2 = memref.cast %arg2: memref<1x5x5x2xi32> to memref<*xi32>
  call @print_memref_i32(%in2) : (memref<*xi32>) -> ()
  return
}