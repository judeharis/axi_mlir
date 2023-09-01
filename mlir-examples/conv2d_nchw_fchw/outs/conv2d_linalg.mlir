#map0 = affine_map<(d0, d1, d2, d3) -> (d0 * 57624 + d1 * 1176 + d2 * 28 + d3 + 1204)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d3, d0, d1, d2)>
#map2 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>
#map3 = affine_map<(d0, d1, d2, d3) -> (d3)>
module {
  func @conv2d_padded_f32(%arg0: memref<1x47x40x28xf32>, %arg1: memref<28x3x3x28xf32>, %arg2: memref<28xf32>) -> memref<1x45x40x28xf32> {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.alloc() : memref<1x49x42x28xf32>
    linalg.fill(%cst, %0) : f32, memref<1x49x42x28xf32> 
    %1 = memref.alloc() : memref<1x49x42x28xf32>
    memref.copy %0, %1 : memref<1x49x42x28xf32> to memref<1x49x42x28xf32>
    memref.dealloc %0 : memref<1x49x42x28xf32>
    %2 = memref.subview %1[0, 1, 1, 0] [1, 47, 40, 28] [1, 1, 1, 1] : memref<1x49x42x28xf32> to memref<1x47x40x28xf32, #map0>
    memref.copy %arg0, %2 : memref<1x47x40x28xf32> to memref<1x47x40x28xf32, #map0>
    %3 = memref.alloc() : memref<3x3x28x28xf32>
    linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%arg1 : memref<28x3x3x28xf32>) outs(%3 : memref<3x3x28x28xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    }
    %4 = memref.alloc() : memref<1x45x40x28xf32>
    linalg.fill(%cst, %4) : f32, memref<1x45x40x28xf32> 
    %5 = memref.alloc() : memref<1x45x40x28xf32>
    memref.copy %4, %5 : memref<1x45x40x28xf32> to memref<1x45x40x28xf32>
    memref.dealloc %4 : memref<1x45x40x28xf32>
    linalg.conv_2d_nhwc_hwcf {dilations = dense<[2, 1]> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%1, %3 : memref<1x49x42x28xf32>, memref<3x3x28x28xf32>) outs(%5 : memref<1x45x40x28xf32>)
    memref.dealloc %3 : memref<3x3x28x28xf32>
    memref.dealloc %1 : memref<1x49x42x28xf32>
    %6 = memref.alloc() : memref<1x45x40x28xf32>
    linalg.generic {indexing_maps = [#map3, #map2, #map2], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%arg2, %5 : memref<28xf32>, memref<1x45x40x28xf32>) outs(%6 : memref<1x45x40x28xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %7 = arith.addf %arg3, %arg4 : f32
      linalg.yield %7 : f32
    }
    memref.dealloc %5 : memref<1x45x40x28xf32>
    return %6 : memref<1x45x40x28xf32>
  }
}

