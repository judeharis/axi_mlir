#map0 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 57624 + s0 + d1 * 1176 + d2 * 28 + d3)>
#map1 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 50400 + s0 + d1 * 1120 + d2 * 28 + d3)>
#map2 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 1792 + s0 + d1 * 224 + d2 * 28 + d3)>
#map3 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 400 + s0 + d1 * 80 + d2 * 16 + d3)>
module {
  func @conv2d_padded_i32(%arg0: memref<1x49x42x28xi32>, %arg1: memref<3x3x28x28xi32>, %arg2: memref<1x45x40x28xi32>) {
    %c3 = arith.constant 3 : index
    %c45 = arith.constant 45 : index
    %c40 = arith.constant 40 : index
    %c0 = arith.constant 0 : index
    %c28 = arith.constant 28 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c45 step %c3 {
      scf.for %arg4 = %c0 to %c40 step %c3 {
        %c5 = arith.constant 5 : index
        %c-1 = arith.constant -1 : index
        %0 = arith.muli %arg4, %c-1 : index
        %c42 = arith.constant 42 : index
        %1 = arith.addi %0, %c42 : index
        %2 = arith.cmpi slt, %c5, %1 : index
        %3 = arith.select %2, %c5, %1 : index
        %4 = memref.subview %arg0[0, %arg3, %arg4, 0] [1, 7, %3, 28] [1, 1, 1, 1] : memref<1x49x42x28xi32> to memref<1x7x?x28xi32, #map0>
        %5 = arith.addi %0, %c40 : index
        %6 = arith.cmpi slt, %c3, %5 : index
        %7 = arith.select %6, %c3, %5 : index
        %8 = memref.subview %arg2[0, %arg3, %arg4, 0] [1, 3, %7, 28] [1, 1, 1, 1] : memref<1x45x40x28xi32> to memref<1x3x?x28xi32, #map1>
        scf.for %arg5 = %c0 to %c1 step %c1 {
          scf.for %arg6 = %c0 to %c3 step %c1 {
            scf.for %arg7 = %c0 to %7 step %c1 {
              scf.for %arg8 = %c0 to %c28 step %c1 {
                scf.for %arg9 = %c0 to %c3 step %c1 {
                  scf.for %arg10 = %c0 to %c3 step %c1 {
                    scf.for %arg11 = %c0 to %c28 step %c1 {
                      %c2 = arith.constant 2 : index
                      %9 = arith.muli %arg9, %c2 : index
                      %10 = arith.addi %arg6, %9 : index
                      %11 = arith.addi %arg7, %arg10 : index
                      %12 = memref.load %4[%arg5, %10, %11, %arg11] : memref<1x7x?x28xi32, #map0>
                      %13 = memref.load %arg1[%arg9, %arg10, %arg11, %arg8] : memref<3x3x28x28xi32>
                      %14 = memref.load %8[%arg5, %arg6, %arg7, %arg8] : memref<1x3x?x28xi32, #map1>
                      %15 = arith.muli %12, %13 : i32
                      %16 = arith.addi %14, %15 : i32
                      memref.store %16, %8[%arg5, %arg6, %arg7, %arg8] : memref<1x3x?x28xi32, #map1>
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
    %c3 = arith.constant 3 : index
    %c5 = arith.constant 5 : index
    %c0 = arith.constant 0 : index
    %c28 = arith.constant 28 : index
    %c16 = arith.constant 16 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c5 step %c3 {
      scf.for %arg4 = %c0 to %c5 step %c3 {
        %c-1 = arith.constant -1 : index
        %0 = arith.muli %arg3, %c-1 : index
        %c7 = arith.constant 7 : index
        %1 = arith.addi %0, %c7 : index
        %2 = arith.cmpi slt, %c5, %1 : index
        %3 = arith.select %2, %c5, %1 : index
        %4 = arith.muli %arg4, %c-1 : index
        %5 = arith.addi %4, %c7 : index
        %6 = arith.cmpi slt, %c5, %5 : index
        %7 = arith.select %6, %c5, %5 : index
        %8 = memref.subview %arg0[0, %arg3, %arg4, 0] [1, %3, %7, 28] [1, 1, 1, 1] : memref<1x8x8x28xf32> to memref<1x?x?x28xf32, #map2>
        %9 = arith.addi %0, %c5 : index
        %10 = arith.cmpi slt, %c3, %9 : index
        %11 = arith.select %10, %c3, %9 : index
        %12 = arith.addi %4, %c5 : index
        %13 = arith.cmpi slt, %c3, %12 : index
        %14 = arith.select %13, %c3, %12 : index
        %15 = memref.subview %arg2[0, %arg3, %arg4, 0] [1, %11, %14, 16] [1, 1, 1, 1] : memref<1x5x5x16xf32> to memref<1x?x?x16xf32, #map3>
        scf.for %arg5 = %c0 to %c1 step %c1 {
          scf.for %arg6 = %c0 to %11 step %c1 {
            scf.for %arg7 = %c0 to %14 step %c1 {
              scf.for %arg8 = %c0 to %c16 step %c1 {
                scf.for %arg9 = %c0 to %c3 step %c1 {
                  scf.for %arg10 = %c0 to %c3 step %c1 {
                    scf.for %arg11 = %c0 to %c28 step %c1 {
                      %16 = arith.addi %arg6, %arg9 : index
                      %17 = arith.addi %arg7, %arg10 : index
                      %18 = memref.load %8[%arg5, %16, %17, %arg11] : memref<1x?x?x28xf32, #map2>
                      %19 = memref.load %arg1[%arg9, %arg10, %arg11, %arg8] : memref<3x3x28x16xf32>
                      %20 = memref.load %15[%arg5, %arg6, %arg7, %arg8] : memref<1x?x?x16xf32, #map3>
                      %21 = arith.mulf %18, %19 : f32
                      %22 = arith.addf %20, %21 : f32
                      memref.store %22, %15[%arg5, %arg6, %arg7, %arg8] : memref<1x?x?x16xf32, #map3>
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
}

