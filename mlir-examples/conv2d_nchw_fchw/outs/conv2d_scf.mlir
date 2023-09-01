#map0 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 36 + s0 + d1 * 9 + d2 * 3 + d3)>
#map1 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 196 + s0 + d1 * 49 + d2 * 7 + d3)>
#map2 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 200 + s0 + d1 * 25 + d2 * 5 + d3)>
module {
  func @conv2d_padded_i32(%arg0: memref<1x49x42x28xi32>, %arg1: memref<3x3x28x28xi32>, %arg2: memref<1x45x40x28xi32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c1 step %c1 {
      %c45 = arith.constant 45 : index
      scf.for %arg4 = %c0 to %c45 step %c1 {
        %c40 = arith.constant 40 : index
        scf.for %arg5 = %c0 to %c40 step %c1 {
          %c28 = arith.constant 28 : index
          scf.for %arg6 = %c0 to %c28 step %c1 {
            %c3 = arith.constant 3 : index
            scf.for %arg7 = %c0 to %c3 step %c1 {
              scf.for %arg8 = %c0 to %c3 step %c1 {
                scf.for %arg9 = %c0 to %c28 step %c1 {
                  %c2 = arith.constant 2 : index
                  %0 = arith.muli %arg7, %c2 : index
                  %1 = arith.addi %arg4, %0 : index
                  %2 = arith.addi %arg5, %arg8 : index
                  %3 = memref.load %arg0[%arg3, %1, %2, %arg9] : memref<1x49x42x28xi32>
                  %4 = memref.load %arg1[%arg7, %arg8, %arg9, %arg6] : memref<3x3x28x28xi32>
                  %5 = memref.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xi32>
                  %6 = arith.muli %3, %4 : i32
                  %7 = arith.addi %5, %6 : i32
                  memref.store %7, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x45x40x28xi32>
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
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c1 step %c1 {
      %c5 = arith.constant 5 : index
      scf.for %arg4 = %c0 to %c5 step %c1 {
        scf.for %arg5 = %c0 to %c5 step %c1 {
          %c16 = arith.constant 16 : index
          scf.for %arg6 = %c0 to %c16 step %c1 {
            %c3 = arith.constant 3 : index
            scf.for %arg7 = %c0 to %c3 step %c1 {
              scf.for %arg8 = %c0 to %c3 step %c1 {
                %c28 = arith.constant 28 : index
                scf.for %arg9 = %c0 to %c28 step %c1 {
                  %0 = arith.addi %arg4, %arg7 : index
                  %1 = arith.addi %arg5, %arg8 : index
                  %2 = memref.load %arg0[%arg3, %0, %1, %arg9] : memref<1x8x8x28xf32>
                  %3 = memref.load %arg1[%arg7, %arg8, %arg9, %arg6] : memref<3x3x28x16xf32>
                  %4 = memref.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x5x5x16xf32>
                  %5 = arith.mulf %2, %3 : f32
                  %6 = arith.addf %4, %5 : f32
                  memref.store %6, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x5x5x16xf32>
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
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c1 step %c1 {
      %c2 = arith.constant 2 : index
      scf.for %arg4 = %c0 to %c2 step %c1 {
        %c3 = arith.constant 3 : index
        scf.for %arg5 = %c0 to %c3 step %c1 {
          scf.for %arg6 = %c0 to %c3 step %c1 {
            scf.for %arg7 = %c0 to %c2 step %c1 {
              scf.for %arg8 = %c0 to %c3 step %c1 {
                scf.for %arg9 = %c0 to %c3 step %c1 {
                  %0 = arith.muli %arg5, %c2 : index
                  %1 = arith.addi %0, %arg8 : index
                  %2 = arith.muli %arg6, %c2 : index
                  %3 = arith.addi %2, %arg9 : index
                  %4 = memref.load %arg0[%arg3, %arg7, %1, %3] : memref<1x2x7x7xi32>
                  %5 = memref.load %arg1[%arg4, %arg7, %arg8, %arg9] : memref<2x2x3x3xi32>
                  %6 = memref.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x2x3x3xi32>
                  %7 = arith.muli %4, %5 : i32
                  %8 = arith.addi %6, %7 : i32
                  memref.store %8, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x2x3x3xi32>
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
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c1 step %c1 {
      %c8 = arith.constant 8 : index
      scf.for %arg4 = %c0 to %c8 step %c1 {
        %c3 = arith.constant 3 : index
        scf.for %arg5 = %c0 to %c3 step %c1 {
          scf.for %arg6 = %c0 to %c3 step %c1 {
            %c4 = arith.constant 4 : index
            scf.for %arg7 = %c0 to %c4 step %c1 {
              scf.for %arg8 = %c0 to %c3 step %c1 {
                scf.for %arg9 = %c0 to %c3 step %c1 {
                  %c2 = arith.constant 2 : index
                  %0 = arith.muli %arg5, %c2 : index
                  %1 = arith.addi %0, %arg8 : index
                  %2 = arith.muli %arg6, %c2 : index
                  %3 = arith.addi %2, %arg9 : index
                  %4 = memref.load %arg0[%arg3, %arg7, %1, %3] : memref<1x4x7x7xi32>
                  %5 = memref.load %arg1[%arg4, %arg7, %arg8, %arg9] : memref<8x4x3x3xi32>
                  %6 = memref.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x3x3xi32>
                  %7 = arith.muli %4, %5 : i32
                  %8 = arith.addi %6, %7 : i32
                  memref.store %8, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x3x3xi32>
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
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c1 step %c1 {
      %c8 = arith.constant 8 : index
      scf.for %arg4 = %c0 to %c8 step %c1 {
        %c5 = arith.constant 5 : index
        scf.for %arg5 = %c0 to %c5 step %c1 {
          scf.for %arg6 = %c0 to %c5 step %c1 {
            %c4 = arith.constant 4 : index
            scf.for %arg7 = %c0 to %c4 step %c1 {
              %c3 = arith.constant 3 : index
              scf.for %arg8 = %c0 to %c3 step %c1 {
                scf.for %arg9 = %c0 to %c3 step %c1 {
                  %0 = arith.addi %arg5, %arg8 : index
                  %1 = arith.addi %arg6, %arg9 : index
                  %2 = memref.load %arg0[%arg3, %arg7, %0, %1] : memref<1x4x7x7xi32>
                  %3 = memref.load %arg1[%arg4, %arg7, %arg8, %arg9] : memref<8x4x3x3xi32>
                  %4 = memref.load %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x5x5xi32>
                  %5 = arith.muli %2, %3 : i32
                  %6 = arith.addi %4, %5 : i32
                  memref.store %6, %arg2[%arg3, %arg4, %arg5, %arg6] : memref<1x8x5x5xi32>
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
        %5 = memref.subview %arg1[%arg4, 0, 0, 0] [1, 4, 3, 3] [1, 1, 1, 1] : memref<8x4x3x3xi32> to memref<1x4x3x3xi32, #map0>
        %6 = accel.send %5, %c0_i32 : (memref<1x4x3x3xi32, #map0>, i32) -> i32
        scf.for %arg5 = %c0 to %c5 step %c1 {
          scf.for %arg6 = %c0 to %c5 step %c1 {
            %7 = accel.sendLiteral %c70_i32 : (i32) -> i32
            %8 = memref.subview %arg0[0, 0, %arg5, %arg6] [1, 4, 3, 3] [1, 1, 1, 1] : memref<1x4x7x7xi32> to memref<1x4x3x3xi32, #map1>
            %9 = accel.send %8, %c0_i32 : (memref<1x4x3x3xi32, #map1>, i32) -> i32
            %10 = accel.sendLiteral %c8_i32 : (i32) -> i32
            %11 = memref.subview %arg2[0, %arg4, %arg5, %arg6] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x8x5x5xi32> to memref<1x1x1x1xi32, #map2>
            %12 = accel.recv %11, %c0_i32 : (memref<1x1x1x1xi32, #map2>, i32) -> i32
          }
        }
      }
    }
    return
  }
}

