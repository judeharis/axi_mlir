#map0 = affine_map<(d0, d1) -> (d0 + d1 * 2)>
#map1 = affine_map<(d0, d1) -> (d0 + d1)>
#map2 = affine_map<(d0, d1) -> (d0 * 2 + d1)>
#map3 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 36 + s0 + d1 * 9 + d2 * 3 + d3)>
#map4 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 196 + s0 + d1 * 49 + d2 * 7 + d3)>
#map5 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 200 + s0 + d1 * 25 + d2 * 5 + d3)>
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
  func @conv2d_B1_IHW7_IC2_FHW3_OC2_ST2_MLIR_ACC_v3_call(%arg0: memref<1x2x7x7xi32>, %arg1: memref<2x2x3x3xi32>, %arg2: memref<1x2x3x3xi32>) {
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 2 {
        affine.for %arg5 = 0 to 3 {
          affine.for %arg6 = 0 to 3 {
            affine.for %arg7 = 0 to 2 {
              affine.for %arg8 = 0 to 3 {
                affine.for %arg9 = 0 to 3 {
                  %0 = affine.apply #map2(%arg5, %arg8)
                  %1 = affine.apply #map2(%arg6, %arg9)
                  %2 = affine.load %arg0[%arg3, %arg7, %0, %1] : memref<1x2x7x7xi32>
                  %3 = affine.load %arg1[%arg4, %arg7, %arg8, %arg9] : memref<2x2x3x3xi32>
                  %4 = affine.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x2x3x3xi32>
                  %5 = arith.muli %2, %3 : i32
                  %6 = arith.addi %4, %5 : i32
                  affine.store %6, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x2x3x3xi32>
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func @conv2d_B1_IHW7_IC4_FHW3_OC8_ST2_MLIR_ACC_v3_call(%arg0: memref<1x4x7x7xi32>, %arg1: memref<8x4x3x3xi32>, %arg2: memref<1x8x3x3xi32>) {
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 8 {
        affine.for %arg5 = 0 to 3 {
          affine.for %arg6 = 0 to 3 {
            affine.for %arg7 = 0 to 4 {
              affine.for %arg8 = 0 to 3 {
                affine.for %arg9 = 0 to 3 {
                  %0 = affine.apply #map2(%arg5, %arg8)
                  %1 = affine.apply #map2(%arg6, %arg9)
                  %2 = affine.load %arg0[%arg3, %arg7, %0, %1] : memref<1x4x7x7xi32>
                  %3 = affine.load %arg1[%arg4, %arg7, %arg8, %arg9] : memref<8x4x3x3xi32>
                  %4 = affine.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x3x3xi32>
                  %5 = arith.muli %2, %3 : i32
                  %6 = arith.addi %4, %5 : i32
                  affine.store %6, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x3x3xi32>
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func @conv2d_B1_IHW7_IC4_FHW3_OC8_ST1_MLIR_ACC_v3_call(%arg0: memref<1x4x7x7xi32>, %arg1: memref<8x4x3x3xi32>, %arg2: memref<1x8x5x5xi32>) {
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 8 {
        affine.for %arg5 = 0 to 5 {
          affine.for %arg6 = 0 to 5 {
            affine.for %arg7 = 0 to 4 {
              affine.for %arg8 = 0 to 3 {
                affine.for %arg9 = 0 to 3 {
                  %0 = affine.apply #map1(%arg5, %arg8)
                  %1 = affine.apply #map1(%arg6, %arg9)
                  %2 = affine.load %arg0[%arg3, %arg7, %0, %1] : memref<1x4x7x7xi32>
                  %3 = affine.load %arg1[%arg4, %arg7, %arg8, %arg9] : memref<8x4x3x3xi32>
                  %4 = affine.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x5x5xi32>
                  %5 = arith.muli %2, %3 : i32
                  %6 = arith.addi %4, %5 : i32
                  affine.store %6, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x5x5xi32>
                }
              }
            }
          }
        }
      }
    }
    return
  }
  func @conv2d_accel_B1_IHW7_IC4_FHW3_OC8_ST1_MLIR_ACC_v3_call(%arg0: memref<1x4x7x7xi32>, %arg1: memref<8x4x3x3xi32>, %arg2: memref<1x8x5x5xi32>) {
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c5 = arith.constant 5 : index
    %c0 = arith.constant 0 : index
    %c1077936128_i32 = arith.constant 1077936128 : i32
    %c369098752_i32 = arith.constant 369098752 : i32
    %c65536_i32 = arith.constant 65536 : i32
    %c373293056_i32 = arith.constant 373293056 : i32
    %c32_i32 = arith.constant 32 : i32
    %c16_i32 = arith.constant 16 : i32
    %c4_i32 = arith.constant 4 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c70_i32 = arith.constant 70 : i32
    %c8_i32 = arith.constant 8 : i32
    accel.init_dma %c1077936128_i32, %c369098752_i32, %c65536_i32, %c373293056_i32, %c65536_i32 : (i32, i32, i32, i32, i32)
    %0 = accel.sendLiteral %c32_i32 : (i32) -> i32
    %1 = accel.sendLiteral %c32_i32 : (i32) -> i32
    scf.for %arg3 = %c0 to %c1 step %c1 {
      scf.for %arg4 = %c0 to %c8 step %c1 {
        %2 = accel.sendLiteral %c16_i32 : (i32) -> i32
        %3 = accel.sendLiteral %c4_i32 : (i32) -> i32
        %4 = accel.sendLiteral %c1_i32 : (i32) -> i32
        %5 = memref.subview %arg1[%arg4, 0, 0, 0] [1, 4, 3, 3] [1, 1, 1, 1] : memref<8x4x3x3xi32> to memref<1x4x3x3xi32, #map3>
        %6 = accel.send %5, %c0_i32 : (memref<1x4x3x3xi32, #map3>, i32) -> i32
        scf.for %arg5 = %c0 to %c5 step %c1 {
          scf.for %arg6 = %c0 to %c5 step %c1 {
            %7 = accel.sendLiteral %c70_i32 : (i32) -> i32
            %8 = memref.subview %arg0[0, 0, %arg5, %arg6] [1, 4, 3, 3] [1, 1, 1, 1] : memref<1x4x7x7xi32> to memref<1x4x3x3xi32, #map4>
            %9 = accel.send %8, %c0_i32 : (memref<1x4x3x3xi32, #map4>, i32) -> i32
            %10 = accel.sendLiteral %c8_i32 : (i32) -> i32
            %11 = memref.subview %arg2[0, %arg4, %arg5, %arg6] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x8x5x5xi32> to memref<1x1x1x1xi32, #map5>
            %12 = accel.recv %11, %c0_i32 : (memref<1x1x1x1xi32, #map5>, i32) -> i32
          }
        }
      }
    }
    return
  }
}

