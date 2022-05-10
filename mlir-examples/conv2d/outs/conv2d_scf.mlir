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
}

