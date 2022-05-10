#map0 = affine_map<(d0, d1) -> (d0 + d1 * 2)>
#map1 = affine_map<(d0, d1) -> (d0 + d1)>
module {
  func @conv2d_padded_i32(%arg0: memref<1x49x42x28xi32>, %arg1: memref<3x3x28x28xi32>, %arg2: memref<1x45x40x28xi32>) {
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 45 {
        affine.for %arg5 = 0 to 40 {
          affine.for %arg6 = 0 to 28 {
            affine.for %arg7 = 0 to 3 {
              affine.for %arg8 = 0 to 3 {
                affine.for %arg9 = 0 to 28 {
                  %0 = affine.apply #map0(%arg4, %arg7)
                  %1 = affine.apply #map1(%arg5, %arg8)
                  %2 = affine.load %arg0[%arg3, %0, %1, %arg9] : memref<1x49x42x28xi32>
                  %3 = affine.load %arg1[%arg7, %arg8, %arg9, %arg6] : memref<3x3x28x28xi32>
                  %4 = affine.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xi32>
                  %5 = arith.muli %2, %3 : i32
                  %6 = arith.addi %4, %5 : i32
                  affine.store %6, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xi32>
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func @conv_2d_nhwc_hwcf(%arg0: memref<1x8x8x28xf32>, %arg1: memref<3x3x28x16xf32>, %arg2: memref<1x5x5x16xf32>) {
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 5 {
        affine.for %arg5 = 0 to 5 {
          affine.for %arg6 = 0 to 16 {
            affine.for %arg7 = 0 to 3 {
              affine.for %arg8 = 0 to 3 {
                affine.for %arg9 = 0 to 28 {
                  %0 = affine.apply #map1(%arg4, %arg7)
                  %1 = affine.apply #map1(%arg5, %arg8)
                  %2 = affine.load %arg0[%arg3, %0, %1, %arg9] : memref<1x8x8x28xf32>
                  %3 = affine.load %arg1[%arg7, %arg8, %arg9, %arg6] : memref<3x3x28x16xf32>
                  %4 = affine.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x5x5x16xf32>
                  %5 = arith.mulf %2, %3 : f32
                  %6 = arith.addf %4, %5 : f32
                  affine.store %6, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x5x5x16xf32>
                }
              }
            }
          }
        }
      }
    }
    return
  }
}

