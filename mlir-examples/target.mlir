
// To run this example:


// mlir-opt target.mlir \
//   -convert-linalg-to-loops -lower-affine \
//   -convert-scf-to-std -convert-vector-to-llvm \
//   -convert-std-to-llvm | mlir-cpu-runner -O3 \
//   -e generalize_matmul_buffer \
//   -entry-point-result=void \
//   -shared-libs=/home/agostini/Development/llvm-project/build/lib/libmlir_runner_utils.so,/home/agostini/Development/llvm-project/build/lib/libmlir_c_runner_utils.so

// AXI4MLIR types
!void_type = type memref<*xi8>

// Other MLIR functions
func private @print_flops(f64)
func private @rtclock() -> f64


#map0 = affine_map<(d0) -> (2, -d0 + 16)>
#map1 = affine_map<(d0) -> (2, -d0 + 8)>
#map2 = affine_map<(d0, d1)[s0] -> (d0 * 8 + s0 + d1)>
#map3 = affine_map<(d0) -> (2, -d0 + 32)>
#map4 = affine_map<(d0, d1)[s0] -> (d0 * 32 + s0 + d1)>

// AXI4MLIR functions
func private @dma_init(index, index, index, index, index) -> ()
func private @dma_free() -> ()
func private @dma_get_regaddr() -> i64 attributes { llvm.emit_c_interface }
func private @dma_get_inbuffer() -> (!void_type)
func private @dma_get_outbuffer() -> (!void_type)

func private @dma_set_transfer(index, i64) -> ()
func private @dma_send(index, index, i64) -> ()

func private @dma_set_store(index, index, i64) -> ()
func private @dma_recv(index, index, i64) -> ()

func @generalize_matmul_buffer(%arg0: memref<16x8xf32>, %arg1: memref<8x32xf32>, %arg2: memref<16x32xf32>) {
  %c2 = constant 2 : index
  %c0 = constant 0 : index
  %c8 = constant 8 : index
  %c16 = constant 16 : index
  %c32 = constant 32 : index

  // Prepare tile sizes
  %ts_a1 = constant 2 : i64
  %ts_a2 = constant 2 : i64
  %ts_b1 = constant 2 : i64
  %ts_b2 = constant 2 : i64
  %ts_c1 = constant 2 : i64
  %ts_c2 = constant 2 : i64

  // Initializes the DMA
  %idx = constant 0 : index
  call @dma_init(%idx, %idx, %idx, %idx, %idx) : (index,index,index,index,index ) -> ()

  scf.for %arg3 = %c0 to %c16 step %c2 {
    scf.for %arg4 = %c0 to %c32 step %c2 {
      scf.for %arg5 = %c0 to %c8 step %c2 {
        %0 = affine.min #map0(%arg3)
        %1 = affine.min #map1(%arg5)
        %2 = memref.subview %arg0[%arg3, %arg5] [%0, %1] [1, 1] : memref<16x8xf32> to memref<?x?xf32, #map2>
        %3 = affine.min #map1(%arg5)
        %4 = affine.min #map3(%arg4)
        %5 = memref.subview %arg1[%arg5, %arg4] [%3, %4] [1, 1] : memref<8x32xf32> to memref<?x?xf32, #map4>
        %6 = affine.min #map0(%arg3)
        %7 = affine.min #map3(%arg4)
        %8 = memref.subview %arg2[%arg3, %arg4] [%6, %7] [1, 1] : memref<16x32xf32> to memref<?x?xf32, #map4>
        
        // Called that will be replaced
        //linalg.matmul ins(%2, %5 : memref<?x?xf32, #map2>, memref<?x?xf32, #map4>) outs(%8 : memref<?x?xf32, #map4>)

        // Sizes of in and out buffers
        %inA_lenght = muli %ts_a1, %ts_a2 : i64
        %inB_lenght = muli %ts_b1, %ts_b2 : i64
        %in_lenght = addi %inA_lenght, %inB_lenght : i64
        %out_lenght = muli %ts_c1, %ts_c2 : i64

        // Get the addresses used for the transfers
        %dma_addr = call @dma_get_regaddr() : () -> i64 // Not sure how to use this yet
        %dma_id = constant 0 : index

        %in_buf_addr = call @dma_get_inbuffer() : () -> (!void_type) // Not sure if it will be used
        %in_buffer_id = constant 0 : index

        %out_buf_addr = call @dma_get_outbuffer() : () -> (!void_type) // Not sure if it will be used
        %out_buffer_id = constant 0 : index

        // Copy data to be transfered and set the transfer size
        // memref.copy() // Copy A tile
        // memref.copy() // Copy B tile
        call @dma_set_transfer (%dma_id, %in_lenght) : (index, i64) -> ()

        // Send the buffers, and start the accelerator
        call @dma_send (%dma_id, %in_buffer_id, %in_lenght) : (index, index, i64) -> ()
        // call #accelator_start
        
        // Prepare copy back and receive buffers 
        call @dma_set_store (%dma_id, %out_buffer_id, %out_lenght) : (index, index, i64) -> ()
        call @dma_recv (%dma_id, %out_buffer_id, %out_lenght) : (index, index, i64) -> ()
        // memref.copy() // Copy C tile
      }
    }
  }
  call @dma_free() : () -> ()
  return
}