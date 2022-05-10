About conv2d in mlir


Most of the time we observed that tosa.conv2d operations are lowered to a series of operations that include:

- linalg.conv_2d_nhwc_hwcf - implementing the convolution
- linalg.generic - implementing the bias add


The convolution respects the following loop ordering

- n = number of images or batch size (usually 1)
- h,w (input) = input image sizes
- c = number of channels in the image / also shared by the filter
- h,w (weights) = filter sizes
- f = number of filters

So a conv2d with:


- n = 1
- h,w = 47,40
- c = 28
- h,w (weights) = 3,3
- f = 28 (can be different than c)

would become:

```mlir
linalg.conv_2d_nhwc_hwcf {dilations = dense<[2, 1]> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%1, %3 : memref<1x49x42x28xf32>, memref<3x3x28x28xf32>) outs(%5 : memref<1x45x40x28xf32>)
```

Note that this also includes dilations and strides, which modify the final output image.


In structured control flow code, this operation becomes:

```mlir
module {
  func @main(%arg0: memref<1x49x42x28xi32>, %arg1: memref<3x3x28x28xi32>, %arg2: memref<1x45x40x28xi32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c1 step %c1 { // Looping over n
      %c45 = arith.constant 45 : index
      scf.for %arg4 = %c0 to %c45 step %c1 { // Looping over h
        %c40 = arith.constant 40 : index
        scf.for %arg5 = %c0 to %c40 step %c1 { // Looping over w
          %c28 = arith.constant 28 : index
          scf.for %arg6 = %c0 to %c28 step %c1 { // Looping over c
            %c3 = arith.constant 3 : index
            scf.for %arg7 = %c0 to %c3 step %c1 { // looping over h_filter
              scf.for %arg8 = %c0 to %c3 step %c1 { // looping over w_filter
                scf.for %arg9 = %c0 to %c28 step %c1 { // looping over f
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
}
```


An example without dilations and strides looks like this:

```mlir
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
```


An example with tiling the outermost dimensions n,h,w by 3 generates this code:

```mlir
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
```