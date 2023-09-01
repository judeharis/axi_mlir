// CHECK-LABEL: @conv2d_padded_i32
func @conv2d_padded_i32(%input: memref<1x49x42x28xi32>, %weights: memref<3x3x28x28xi32>, %out: memref<1x45x40x28xi32>) -> () {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<[2, 1]> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%input, %weights : memref<1x49x42x28xi32>, memref<3x3x28x28xi32>) outs(%out : memref<1x45x40x28xi32>)
  return
}


func @conv_2d_nhwc_hwcf(%arg0: memref<1x8x8x28xf32>, %arg1: memref<3x3x28x16xf32>, %arg2: memref<1x5x5x16xf32>) {
  linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : tensor<2xi64>,
                          strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x8x8x28xf32>, memref<3x3x28x16xf32>)
    outs (%arg2: memref<1x5x5x16xf32>)
  return
}

func @conv2d_B1_IHW7_IC2_FHW3_OC2_ST2_MLIR_ACC_v3_call(
  %arg0: memref<1x2x7x7xi32>, 
  %arg1: memref<2x2x3x3xi32>, 
  %arg2: memref<1x2x3x3xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x2x7x7xi32>, memref<2x2x3x3xi32>)
    outs (%arg2: memref<1x2x3x3xi32>)
  return
}

func @conv2d_B1_IHW7_IC4_FHW3_OC8_ST2_MLIR_ACC_v3_call(
  %arg0: memref<1x4x7x7xi32>, 
  %arg1: memref<8x4x3x3xi32>, 
  %arg2: memref<1x8x3x3xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x4x7x7xi32>, memref<8x4x3x3xi32>)
    outs (%arg2: memref<1x8x3x3xi32>)
  return
}

#map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 196 + s0 + d1 * 49 + d2 * 7 + d3)>
#map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 36 + s0 + d1 * 9 + d2 * 3 + d3)>
#map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 72 + s0 + d1 * 9 + d2 * 3 + d3)>
#map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 200 + s0 + d1 * 25 + d2 * 5 + d3)>
// valid - sends 1 output at a time
func @conv2d_B1_IHW7_IC4_FHW3_OC8_ST1_MLIR_ACC_v3_call(%arg0: memref<1x4x7x7xi32>, %arg1: memref<8x4x3x3xi32>, %arg2: memref<1x8x5x5xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 8 : index
  %c5 = arith.constant 5 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c3 = arith.constant 3 : index

  %c1077936128_i32 = arith.constant 1077936128 : i32
  %c369098752_i32 = arith.constant 369098752 : i32
  %c65536_i32 = arith.constant 65536 : i32
  %c373293056_i32 = arith.constant 373293056 : i32
  accel.init_dma %c1077936128_i32, %c369098752_i32, %c65536_i32, %c373293056_i32, %c65536_i32 : (i32, i32, i32, i32, i32)

  // unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
  // uint32_t opcode = 32;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = fh;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();

  %c32_i32 = arith.constant 32 : i32
  %offset = accel.sendLiteral %c32_i32  : ( i32 ) -> i32
  %c3_i32 = arith.constant 32 : i32
  %offset2 = accel.sendLiteral %c3_i32  : ( i32 ) -> i32


  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
    // // Send IC parameter
    // uint32_t opcode = 16;
    // dma_inbuffer[0] = opcode;
    // dma_inbuffer[1] = p.ic;
    // dma1.dma_start_send(2, 0);
    // dma1.dma_wait_send();
    %c16_i32 = arith.constant 16 : i32
    %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
    %c4_i32 = arith.constant 4 : i32
    %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

    // // Send Filter data for current OC
    // int data_len = 0;
    // opcode = 1;
    // dma_inbuffer[data_len++] = opcode;
    %c1_i32 = arith.constant 1 : i32
    %offset5 = accel.sendLiteral %c1_i32  : ( i32 ) -> i32

    //   for (int ic = 0; ic < p.ic; ic++) {     // C
    //   for (int fh = 0; fh < p.fh; fh++) {   // H
    //     for (int fw = 0; fw < p.fw; fw++) { // W
    //       dma_inbuffer[data_len++] =
    //           filter[(oc * p.ic * p.fh * p.fw) + (ic * p.fh * p.fw) +
    //                  (fh * p.fw) + fw];
    //     }
    //   }
    // }    
    //     dma1.dma_start_send(data_len, 0);
    // dma1.dma_wait_send();
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 4, 3, 3] [1, 1, 1, 1] : memref<8x4x3x3xi32> to memref<1x4x3x3xi32, #map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x4x3x3xi32, #map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4, %arg5] [1, 4, 3, 3] [1, 1, 1, 1] : memref<1x4x7x7xi32> to memref<1x4x3x3xi32, #map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x4x3x3xi32, #map8>, i32) -> i32

        // data_len = 0;
        // opcode = 8;
        // dma_inbuffer[0] = opcode;
        // dma1.dma_start_send(1, 0);
        // dma1.dma_wait_send();
        %c8_i32 = arith.constant 8 : i32
        %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // dma1.dma_start_recv(p.oh * p.ow, 0);
        // dma1.dma_wait_recv();
        %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x8x5x5xi32> to memref<1x1x1x1xi32, #map11>
        %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #map11>, i32) -> i32
        }
      }
    }
  }
  return
}



#map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 196 + s0 + d1 * 49 + d2 * 7 + d3)>
#map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 36 + s0 + d1 * 9 + d2 * 3 + d3)>
#map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 72 + s0 + d1 * 9 + d2 * 3 + d3)>
#map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 200 + s0 + d1 * 25 + d2 * 5 + d3)>
// valid - sends OHWxOW 
func @conv2d_B1_IHW7_IC4_FHW3_OC8_ST1_MLIR_ACC_v3_call(%arg0: memref<1x4x7x7xi32>, %arg1: memref<8x4x3x3xi32>, %arg2: memref<1x8x5x5xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 8 : index
  %c5 = arith.constant 5 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c3 = arith.constant 3 : index

  %c1077936128_i32 = arith.constant 1077936128 : i32
  %c369098752_i32 = arith.constant 369098752 : i32
  %c65536_i32 = arith.constant 65536 : i32
  %c373293056_i32 = arith.constant 373293056 : i32
  accel.init_dma %c1077936128_i32, %c369098752_i32, %c65536_i32, %c373293056_i32, %c65536_i32 : (i32, i32, i32, i32, i32)

  // unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
  // uint32_t opcode = 32;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = fh;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();

  %c32_i32 = arith.constant 32 : i32
  %offset = accel.sendLiteral %c32_i32  : ( i32 ) -> i32
  %c3_i32 = arith.constant 3 : i32
  %offset2 = accel.sendLiteral %c3_i32  : ( i32 ) -> i32


  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
    // // Send IC parameter
    // uint32_t opcode = 16;
    // dma_inbuffer[0] = opcode;
    // dma_inbuffer[1] = p.ic;
    // dma1.dma_start_send(2, 0);
    // dma1.dma_wait_send();
    %c16_i32 = arith.constant 16 : i32
    %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
    %c4_i32 = arith.constant 4 : i32
    %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

    // // Send Filter data for current OC
    // int data_len = 0;
    // opcode = 1;
    // dma_inbuffer[data_len++] = opcode;
    %c1_i32 = arith.constant 1 : i32
    %offset5 = accel.sendLiteral %c1_i32  : ( i32 ) -> i32

    //   for (int ic = 0; ic < p.ic; ic++) {     // C
    //   for (int fh = 0; fh < p.fh; fh++) {   // H
    //     for (int fw = 0; fw < p.fw; fw++) { // W
    //       dma_inbuffer[data_len++] =
    //           filter[(oc * p.ic * p.fh * p.fw) + (ic * p.fh * p.fw) +
    //                  (fh * p.fw) + fw];
    //     }
    //   }
    // }    
    //     dma1.dma_start_send(data_len, 0);
    // dma1.dma_wait_send();
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 4, 3, 3] [1, 1, 1, 1] : memref<8x4x3x3xi32> to memref<1x4x3x3xi32, #map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x4x3x3xi32, #map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4, %arg5] [1, 4, 3, 3] [1, 1, 1, 1] : memref<1x4x7x7xi32> to memref<1x4x3x3xi32, #map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x4x3x3xi32, #map8>, i32) -> i32

        // data_len = 0;
        // opcode = 8;
        // dma_inbuffer[0] = opcode;
        // dma1.dma_start_send(1, 0);
        // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 8 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // dma1.dma_start_recv(p.oh * p.ow, 0);
        // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x8x5x5xi32> to memref<1x1x1x1xi32, #map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 5, 5] [1, 1, 1, 1] : memref<1x8x5x5xi32> to memref<1x1x5x5xi32, #map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x5x5xi32, #map11>, i32) -> i32




    }
  }
  return
}
