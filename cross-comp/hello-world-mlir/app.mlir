// RUN: mlir-opt %s -convert-linalg-to-loops -convert-scf-to-std -convert-linalg-to-llvm -lower-affine -convert-scf-to-std --convert-memref-to-llvm -convert-std-to-llvm -reconcile-unrealized-casts | \
// RUN: mlir-cpu-runner -e main -entry-point-result=void \
// RUN:   -shared-libs=%mlir_integration_test_dir/libmlir_runner_utils%shlibext \
// RUN: | FileCheck %s

func private @print_memref_f32(memref<*xf32>)

// Creates and returns a 1-D buffer of size %s1 filled with the value %f
func @alloc_1d_filled_f32(%s1 : index, %f : f32) -> memref<?xf32> {
  %buf = memref.alloc(%s1) : memref<?xf32>
  linalg.fill(%f, %buf) : f32, memref<?xf32>
  return %buf : memref<?xf32>
}

func @conv_1d(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>) {
  linalg.conv_1d ins (%arg0, %arg1: memref<?xf32>, memref<?xf32>)
                outs (%arg2: memref<?xf32>)
  return
}

func @main() -> i32 {
  %c3 = arith.constant 3 : index
  %c6 = arith.constant 6 : index
  %c8 = arith.constant 8 : index
  %f10 = arith.constant 10.00000e+00 : f32
  %val = arith.constant 2.00000e+00 : f32
  %zero = arith.constant 0.00000e+00 : f32

  %filter1D = call @alloc_1d_filled_f32(%c3, %val) : (index, f32) -> (memref<?xf32>)
  %in1D = call @alloc_1d_filled_f32(%c8, %val) : (index, f32) -> (memref<?xf32>)
  %out1D = call @alloc_1d_filled_f32(%c6, %zero) : (index, f32) -> (memref<?xf32>)
  memref.store %f10, %in1D[%c3] : memref<?xf32>
  
  %in1D_ = memref.cast %in1D : memref<?xf32> to memref<*xf32>
  %filter1D_ = memref.cast %filter1D : memref<?xf32> to memref<*xf32>
  %out1D_ = memref.cast %out1D : memref<?xf32> to memref<*xf32>
  
  call @print_memref_f32(%in1D_): (memref<*xf32>) -> ()
  call @print_memref_f32(%filter1D_): (memref<*xf32>) -> ()

  call @conv_1d(%in1D, %filter1D, %out1D) : (memref<?xf32>, memref<?xf32>, memref<?xf32>) -> ()
  call @print_memref_f32(%out1D_): (memref<*xf32>) -> ()

  memref.dealloc %filter1D : memref<?xf32>
  memref.dealloc %in1D : memref<?xf32>
  memref.dealloc %out1D : memref<?xf32>

  %rv = arith.constant 0 : i32
  return %rv : i32
}

// CHECK:       Unranked Memref {{.*}}
// CHECK-NEXT:  [12, 28, 28, 28, 12, 12]
