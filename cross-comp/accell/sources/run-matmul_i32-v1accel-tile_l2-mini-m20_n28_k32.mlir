// RUN: mlir-opt -test-linalg-to-axi4mlir="flow-cpu-accumulation" \
// RUN:  -convert-linalg-to-loops -lower-affine -convert-scf-to-cf \
// RUN:  -convert-vector-to-llvm -convert-memref-to-llvm -convert-std-to-llvm \
// RUN:  -reconcile-unrealized-casts %s | \
// RUN: mlir-cpu-runner \
// RUN:  -O0 -e main -entry-point-result=void \
// RUN:  -shared-libs=%mlir_runner_utils_dir/libmlir_mockaxi_runner_utils%shlibext \
// RUN:  -shared-libs=%mlir_runner_utils_dir/libmlir_runner_utils%shlibext | \
// RUN: FileCheck %s


// #  ifdef MINI_DATASET
// #   define NI 20
// #   define NJ 25 -> 28
// #   define NK 30 -> 32
// #  endif

// #  ifdef SMALL_DATASET
// #   define NI 60
// #   define NJ 70 -> 72
// #   define NK 80
// #  endif

// #  ifdef MEDIUM_DATASET
// #   define NI 200
// #   define NJ 220
// #   define NK 240
// #  endif

// #  ifdef LARGE_DATASET
// #   define NI 1000
// #   define NJ 1100
// #   define NK 1200
// #  endif

// #  ifdef EXTRALARGE_DATASET
// #   define NI 2000
// #   define NJ 2300
// #   define NK 2600
// #  endif

// MLIR Runner
func private @print_memref_i32(memref<*xi32>)

//  MINI_DATASET
// This is the only code that gets modified by the -test-linalg-to-axi4mlir pass
func @matmul_call(%A: memref<20x32xi32>, %B: memref<32x28xi32>, %C: memref<20x28xi32>) {
  linalg.matmul {__internal_linalg_transform__="MEM"}
   ins(%A, %B: memref<20x32xi32>, memref<32x28xi32>)
   outs(%C: memref<20x28xi32>)
  return
}

//CHECK: dma_init

// This is a repeating pattern. Only check the first 2 iterations.
//CHECK: dma_start_send
//CHECK: dma_wait_send
//CHECK: dma_start_recv
//
//CHECK: dma_start_send
//CHECK: dma_wait_send
//CHECK: dma_start_recv

// Many more will happen

//CHECK: dma_free

// All functions below are only part of the driver code
func @alloc_2d_filled_i32(%s1 : index, %s2 : index, %f : i32) -> memref<?x?xi32> {
  %buf = memref.alloc(%s1, %s2) : memref<?x?xi32>
  linalg.fill(%f, %buf) : i32, memref<?x?xi32>
  return %buf : memref<?x?xi32>
}

func @alloc_2d_filled_inc_i32(%arg0: index, %arg1: index, %arg2: i32) -> memref<?x?xi32> {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 100 : i32
  %0 = memref.alloc(%arg0, %arg1) : memref<?x?xi32>
  linalg.fill(%arg2, %0) : i32, memref<?x?xi32>
  scf.for %arg3 = %c0 to %arg0 step %c1 {
    scf.for %arg4 = %c0 to %arg1 step %c1 {
      %1 = arith.index_cast %arg3 : index to i32
      %2 = arith.index_cast %arg4 : index to i32
      %5 = arith.muli %1, %cst : i32
      %6 = arith.addi %2, %5 : i32
      memref.store %6, %0[%arg3, %arg4] : memref<?x?xi32>
    }
  }
  return %0 : memref<?x?xi32>
}

#id_2d = affine_map<(i, j) -> (i, j)>
#pointwise_2d_trait = {
  indexing_maps = [#id_2d, #id_2d],
  iterator_types = ["parallel", "parallel"]
}

func @main() {
  %c2 = arith.constant 2 : index
  %c4 = arith.constant 4 : index
  %c0 = arith.constant 0 : index
  %c8 = arith.constant 32 : index
  %c16 = arith.constant 20 : index
  %c32 = arith.constant 28 : index

  %c1_0 = arith.constant 1 : i64
  %cst_1 = arith.constant 1 : i32
  %cst_0 = arith.constant 0 : i32

  // Initializes the DMA
  %idx = arith.constant 0 : index

  %A = call @alloc_2d_filled_inc_i32(%c16, %c8, %cst_1) : (index, index, i32) -> (memref<?x?xi32>)
  %B = call @alloc_2d_filled_i32(%c8, %c32, %cst_1) : (index, index, i32) -> (memref<?x?xi32>)
  %C = call @alloc_2d_filled_i32(%c16, %c32, %cst_0) : (index, index, i32) -> (memref<?x?xi32>)
  %Ctmp = call @alloc_2d_filled_i32(%c16, %c32, %cst_0) : (index, index, i32) -> (memref<?x?xi32>)

  %A_typed = memref.cast %A: memref<?x?xi32> to memref<20x32xi32>
  %B_typed = memref.cast %B: memref<?x?xi32> to memref<32x28xi32>
  %C_typed = memref.cast %C: memref<?x?xi32> to memref<20x28xi32>
  %Ctmp_typed = memref.cast %Ctmp: memref<?x?xi32> to memref<20x28xi32>
  
  %in1 = memref.cast %A_typed: memref<20x32xi32> to memref<*xi32>
  %in2 = memref.cast %B_typed: memref<32x28xi32> to memref<*xi32>
  %out1 = memref.cast %C_typed: memref<20x28xi32> to memref<*xi32>
  %outtmp = memref.cast %Ctmp_typed: memref<20x28xi32> to memref<*xi32>

  call @print_memref_i32(%in1) : (memref<*xi32>) -> ()
  call @print_memref_i32(%in2) : (memref<*xi32>) -> ()

  call @matmul_call(%A_typed, %B_typed, %C_typed) : (memref<20x32xi32>, memref<32x28xi32>, memref<20x28xi32>) ->()

  call @print_memref_i32(%out1) : (memref<*xi32>) -> ()
  return
}

