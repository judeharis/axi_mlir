#map0 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 57624 + s0 + d1 * 1176 + d2 * 28 + d3)>
#map1 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 2352 + s0 + d1 * 784 + d2 * 28 + d3)>
#map2 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 50400 + s0 + d1 * 1120 + d2 * 28 + d3)>
#map3 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 1792 + s0 + d1 * 224 + d2 * 28 + d3)>
#map4 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 1344 + s0 + d1 * 448 + d2 * 16 + d3)>
#map5 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 400 + s0 + d1 * 80 + d2 * 16 + d3)>
#map6 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 98 + s0 + d1 * 49 + d2 * 7 + d3)>
#map7 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 18 + s0 + d1 * 9 + d2 * 3 + d3)>
#map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 196 + s0 + d1 * 49 + d2 * 7 + d3)>
#map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 36 + s0 + d1 * 9 + d2 * 3 + d3)>
#map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 72 + s0 + d1 * 9 + d2 * 3 + d3)>
#map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 200 + s0 + d1 * 25 + d2 * 5 + d3)>
module {
  func private @copy_from_outbuffer_i32(memref<*xi32>, i32) -> i32
  func private @dma_start_recv(i32, i32) -> i32
  func private @dma_wait_recv()
  func private @copy_to_inbuffer_i32(memref<*xi32>, i32) -> i32
  func private @dma_start_send(i32, i32) -> i32
  func private @dma_wait_send()
  func private @dma_init(i32, i32, i32, i32, i32)
  func private @dma_free()
  func @conv2d_padded_i32(%arg0: memref<1x49x42x28xi32>, %arg1: memref<3x3x28x28xi32>, %arg2: memref<1x45x40x28xi32>) {
    %c1 = arith.constant 1 : index
    %c45 = arith.constant 45 : index
    %c40 = arith.constant 40 : index
    %c28 = arith.constant 28 : index
    %c0 = arith.constant 0 : index
    %c3 = arith.constant 3 : index
    scf.for %arg3 = %c0 to %c45 step %c1 {
      scf.for %arg4 = %c0 to %c40 step %c1 {
        scf.for %arg5 = %c0 to %c28 step %c1 {
          %0 = memref.subview %arg0[0, %arg3, %arg4, 0] [1, 5, 3, 28] [1, 1, 1, 1] : memref<1x49x42x28xi32> to memref<1x5x3x28xi32, #map0>
          %1 = memref.subview %arg1[0, 0, 0, %arg5] [3, 3, 28, 1] [1, 1, 1, 1] : memref<3x3x28x28xi32> to memref<3x3x28x1xi32, #map1>
          %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x45x40x28xi32> to memref<1x1x1x1xi32, #map2>
          scf.for %arg6 = %c0 to %c1 step %c1 {
            scf.for %arg7 = %c0 to %c1 step %c1 {
              scf.for %arg8 = %c0 to %c1 step %c1 {
                scf.for %arg9 = %c0 to %c1 step %c1 {
                  scf.for %arg10 = %c0 to %c3 step %c1 {
                    scf.for %arg11 = %c0 to %c3 step %c1 {
                      scf.for %arg12 = %c0 to %c28 step %c1 {
                        %c2 = arith.constant 2 : index
                        %3 = arith.muli %arg10, %c2 : index
                        %4 = arith.addi %arg7, %3 : index
                        %5 = arith.addi %arg8, %arg11 : index
                        %6 = memref.load %0[%arg6, %4, %5, %arg12] : memref<1x5x3x28xi32, #map0>
                        %7 = memref.load %1[%arg10, %arg11, %arg12, %arg9] : memref<3x3x28x1xi32, #map1>
                        %8 = memref.load %2[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map2>
                        %9 = arith.muli %6, %7 : i32
                        %10 = arith.addi %8, %9 : i32
                        memref.store %10, %2[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map2>
                      }
                    }
                  }
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
    %c1 = arith.constant 1 : index
    %c5 = arith.constant 5 : index
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %c28 = arith.constant 28 : index
    %c3 = arith.constant 3 : index
    scf.for %arg3 = %c0 to %c5 step %c1 {
      scf.for %arg4 = %c0 to %c5 step %c1 {
        scf.for %arg5 = %c0 to %c16 step %c1 {
          %0 = memref.subview %arg0[0, %arg3, %arg4, 0] [1, 3, 3, 28] [1, 1, 1, 1] : memref<1x8x8x28xf32> to memref<1x3x3x28xf32, #map3>
          %1 = memref.subview %arg1[0, 0, 0, %arg5] [3, 3, 28, 1] [1, 1, 1, 1] : memref<3x3x28x16xf32> to memref<3x3x28x1xf32, #map4>
          %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x5x5x16xf32> to memref<1x1x1x1xf32, #map5>
          scf.for %arg6 = %c0 to %c1 step %c1 {
            scf.for %arg7 = %c0 to %c1 step %c1 {
              scf.for %arg8 = %c0 to %c1 step %c1 {
                scf.for %arg9 = %c0 to %c1 step %c1 {
                  scf.for %arg10 = %c0 to %c3 step %c1 {
                    scf.for %arg11 = %c0 to %c3 step %c1 {
                      scf.for %arg12 = %c0 to %c28 step %c1 {
                        %3 = arith.addi %arg7, %arg10 : index
                        %4 = arith.addi %arg8, %arg11 : index
                        %5 = memref.load %0[%arg6, %3, %4, %arg12] : memref<1x3x3x28xf32, #map3>
                        %6 = memref.load %1[%arg10, %arg11, %arg12, %arg9] : memref<3x3x28x1xf32, #map4>
                        %7 = memref.load %2[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xf32, #map5>
                        %8 = arith.mulf %5, %6 : f32
                        %9 = arith.addf %7, %8 : f32
                        memref.store %9, %2[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xf32, #map5>
                      }
                    }
                  }
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
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %c0 = arith.constant 0 : index
    scf.for %arg3 = %c0 to %c2 step %c1 {
      scf.for %arg4 = %c0 to %c3 step %c1 {
        scf.for %arg5 = %c0 to %c3 step %c1 {
          %0 = arith.muli %arg4, %c2 : index
          %1 = arith.muli %arg5, %c2 : index
          %2 = memref.subview %arg0[0, 0, %0, %1] [1, 2, 3, 3] [1, 1, 1, 1] : memref<1x2x7x7xi32> to memref<1x2x3x3xi32, #map6>
          %3 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 2, 3, 3] [1, 1, 1, 1] : memref<2x2x3x3xi32> to memref<1x2x3x3xi32, #map7>
          %4 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x2x3x3xi32> to memref<1x1x1x1xi32, #map7>
          scf.for %arg6 = %c0 to %c1 step %c1 {
            scf.for %arg7 = %c0 to %c1 step %c1 {
              scf.for %arg8 = %c0 to %c1 step %c1 {
                scf.for %arg9 = %c0 to %c1 step %c1 {
                  scf.for %arg10 = %c0 to %c2 step %c1 {
                    scf.for %arg11 = %c0 to %c3 step %c1 {
                      scf.for %arg12 = %c0 to %c3 step %c1 {
                        %5 = arith.muli %arg8, %c2 : index
                        %6 = arith.addi %5, %arg11 : index
                        %7 = arith.muli %arg9, %c2 : index
                        %8 = arith.addi %7, %arg12 : index
                        %9 = memref.load %2[%arg6, %arg10, %6, %8] : memref<1x2x3x3xi32, #map6>
                        %10 = memref.load %3[%arg7, %arg10, %arg11, %arg12] : memref<1x2x3x3xi32, #map7>
                        %11 = memref.load %4[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map7>
                        %12 = arith.muli %9, %10 : i32
                        %13 = arith.addi %11, %12 : i32
                        memref.store %13, %4[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map7>
                      }
                    }
                  }
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
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c3 = arith.constant 3 : index
    %c0 = arith.constant 0 : index
    %c4 = arith.constant 4 : index
    scf.for %arg3 = %c0 to %c8 step %c1 {
      scf.for %arg4 = %c0 to %c3 step %c1 {
        scf.for %arg5 = %c0 to %c3 step %c1 {
          %c2 = arith.constant 2 : index
          %0 = arith.muli %arg4, %c2 : index
          %1 = arith.muli %arg5, %c2 : index
          %2 = memref.subview %arg0[0, 0, %0, %1] [1, 4, 3, 3] [1, 1, 1, 1] : memref<1x4x7x7xi32> to memref<1x4x3x3xi32, #map8>
          %3 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 4, 3, 3] [1, 1, 1, 1] : memref<8x4x3x3xi32> to memref<1x4x3x3xi32, #map9>
          %4 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x8x3x3xi32> to memref<1x1x1x1xi32, #map10>
          scf.for %arg6 = %c0 to %c1 step %c1 {
            scf.for %arg7 = %c0 to %c1 step %c1 {
              scf.for %arg8 = %c0 to %c1 step %c1 {
                scf.for %arg9 = %c0 to %c1 step %c1 {
                  scf.for %arg10 = %c0 to %c4 step %c1 {
                    scf.for %arg11 = %c0 to %c3 step %c1 {
                      scf.for %arg12 = %c0 to %c3 step %c1 {
                        %5 = arith.muli %arg8, %c2 : index
                        %6 = arith.addi %5, %arg11 : index
                        %7 = arith.muli %arg9, %c2 : index
                        %8 = arith.addi %7, %arg12 : index
                        %9 = memref.load %2[%arg6, %arg10, %6, %8] : memref<1x4x3x3xi32, #map8>
                        %10 = memref.load %3[%arg7, %arg10, %arg11, %arg12] : memref<1x4x3x3xi32, #map9>
                        %11 = memref.load %4[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map10>
                        %12 = arith.muli %9, %10 : i32
                        %13 = arith.addi %11, %12 : i32
                        memref.store %13, %4[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map10>
                      }
                    }
                  }
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
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c5 = arith.constant 5 : index
    %c0 = arith.constant 0 : index
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    scf.for %arg3 = %c0 to %c8 step %c1 {
      scf.for %arg4 = %c0 to %c5 step %c1 {
        scf.for %arg5 = %c0 to %c5 step %c1 {
          %0 = memref.subview %arg0[0, 0, %arg4, %arg5] [1, 4, 3, 3] [1, 1, 1, 1] : memref<1x4x7x7xi32> to memref<1x4x3x3xi32, #map8>
          %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 4, 3, 3] [1, 1, 1, 1] : memref<8x4x3x3xi32> to memref<1x4x3x3xi32, #map9>
          %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x8x5x5xi32> to memref<1x1x1x1xi32, #map11>
          scf.for %arg6 = %c0 to %c1 step %c1 {
            scf.for %arg7 = %c0 to %c1 step %c1 {
              scf.for %arg8 = %c0 to %c1 step %c1 {
                scf.for %arg9 = %c0 to %c1 step %c1 {
                  scf.for %arg10 = %c0 to %c4 step %c1 {
                    scf.for %arg11 = %c0 to %c3 step %c1 {
                      scf.for %arg12 = %c0 to %c3 step %c1 {
                        %3 = arith.addi %arg8, %arg11 : index
                        %4 = arith.addi %arg9, %arg12 : index
                        %5 = memref.load %0[%arg6, %arg10, %3, %4] : memref<1x4x3x3xi32, #map8>
                        %6 = memref.load %1[%arg7, %arg10, %arg11, %arg12] : memref<1x4x3x3xi32, #map9>
                        %7 = memref.load %2[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map11>
                        %8 = arith.muli %5, %6 : i32
                        %9 = arith.addi %7, %8 : i32
                        memref.store %9, %2[%arg6, %arg7, %arg8, %arg9] : memref<1x1x1x1xi32, #map11>
                      }
                    }
                  }
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
    call @dma_init(%c1077936128_i32, %c369098752_i32, %c65536_i32, %c373293056_i32, %c65536_i32) : (i32, i32, i32, i32, i32) -> ()
    %0 = memref.alloc() : memref<i32>
    memref.store %c32_i32, %0[] : memref<i32>
    %1 = memref.cast %0 : memref<i32> to memref<*xi32>
    %2 = call @copy_to_inbuffer_i32(%1, %c0_i32) : (memref<*xi32>, i32) -> i32
    %3 = call @dma_start_send(%c1_i32, %c0_i32) : (i32, i32) -> i32
    call @dma_wait_send() : () -> ()
    memref.dealloc %0 : memref<i32>
    %4 = memref.alloc() : memref<i32>
    memref.store %c32_i32, %4[] : memref<i32>
    %5 = memref.cast %4 : memref<i32> to memref<*xi32>
    %6 = call @copy_to_inbuffer_i32(%5, %c0_i32) : (memref<*xi32>, i32) -> i32
    %7 = call @dma_start_send(%c1_i32, %c0_i32) : (i32, i32) -> i32
    call @dma_wait_send() : () -> ()
    memref.dealloc %4 : memref<i32>
    scf.for %arg3 = %c0 to %c8 step %c1 {
      %8 = memref.alloc() : memref<i32>
      memref.store %c16_i32, %8[] : memref<i32>
      %9 = memref.cast %8 : memref<i32> to memref<*xi32>
      %10 = call @copy_to_inbuffer_i32(%9, %c0_i32) : (memref<*xi32>, i32) -> i32
      %11 = call @dma_start_send(%c1_i32, %c0_i32) : (i32, i32) -> i32
      call @dma_wait_send() : () -> ()
      memref.dealloc %8 : memref<i32>
      %12 = memref.alloc() : memref<i32>
      memref.store %c4_i32, %12[] : memref<i32>
      %13 = memref.cast %12 : memref<i32> to memref<*xi32>
      %14 = call @copy_to_inbuffer_i32(%13, %c0_i32) : (memref<*xi32>, i32) -> i32
      %15 = call @dma_start_send(%c1_i32, %c0_i32) : (i32, i32) -> i32
      call @dma_wait_send() : () -> ()
      memref.dealloc %12 : memref<i32>
      %16 = memref.alloc() : memref<i32>
      memref.store %c1_i32, %16[] : memref<i32>
      %17 = memref.cast %16 : memref<i32> to memref<*xi32>
      %18 = call @copy_to_inbuffer_i32(%17, %c0_i32) : (memref<*xi32>, i32) -> i32
      %19 = call @dma_start_send(%c1_i32, %c0_i32) : (i32, i32) -> i32
      call @dma_wait_send() : () -> ()
      memref.dealloc %16 : memref<i32>
      %20 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 4, 3, 3] [1, 1, 1, 1] : memref<8x4x3x3xi32> to memref<1x4x3x3xi32, #map9>
      %21 = memref.cast %20 : memref<1x4x3x3xi32, #map9> to memref<*xi32>
      %22 = call @copy_to_inbuffer_i32(%21, %c0_i32) : (memref<*xi32>, i32) -> i32
      %c36_i32 = arith.constant 36 : i32
      %23 = call @dma_start_send(%c36_i32, %c0_i32) : (i32, i32) -> i32
      call @dma_wait_send() : () -> ()
      scf.for %arg4 = %c0 to %c5 step %c1 {
        scf.for %arg5 = %c0 to %c5 step %c1 {
          %24 = memref.alloc() : memref<i32>
          memref.store %c70_i32, %24[] : memref<i32>
          %25 = memref.cast %24 : memref<i32> to memref<*xi32>
          %26 = call @copy_to_inbuffer_i32(%25, %c0_i32) : (memref<*xi32>, i32) -> i32
          %27 = call @dma_start_send(%c1_i32, %c0_i32) : (i32, i32) -> i32
          call @dma_wait_send() : () -> ()
          memref.dealloc %24 : memref<i32>
          %28 = memref.subview %arg0[0, 0, %arg4, %arg5] [1, 4, 3, 3] [1, 1, 1, 1] : memref<1x4x7x7xi32> to memref<1x4x3x3xi32, #map8>
          %29 = memref.cast %28 : memref<1x4x3x3xi32, #map8> to memref<*xi32>
          %30 = call @copy_to_inbuffer_i32(%29, %c0_i32) : (memref<*xi32>, i32) -> i32
          %31 = call @dma_start_send(%c36_i32, %c0_i32) : (i32, i32) -> i32
          call @dma_wait_send() : () -> ()
          %32 = memref.alloc() : memref<i32>
          memref.store %c8_i32, %32[] : memref<i32>
          %33 = memref.cast %32 : memref<i32> to memref<*xi32>
          %34 = call @copy_to_inbuffer_i32(%33, %c0_i32) : (memref<*xi32>, i32) -> i32
          %35 = call @dma_start_send(%c1_i32, %c0_i32) : (i32, i32) -> i32
          call @dma_wait_send() : () -> ()
          memref.dealloc %32 : memref<i32>
          %36 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x8x5x5xi32> to memref<1x1x1x1xi32, #map11>
          %37 = memref.cast %36 : memref<1x1x1x1xi32, #map11> to memref<*xi32>
          %38 = call @dma_start_recv(%c1_i32, %c0_i32) : (i32, i32) -> i32
          call @dma_wait_recv() : () -> ()
          %39 = call @copy_from_outbuffer_i32(%37, %c0_i32) : (memref<*xi32>, i32) -> i32
        }
      }
    }
    call @dma_free() : () -> ()
    return
  }
}

