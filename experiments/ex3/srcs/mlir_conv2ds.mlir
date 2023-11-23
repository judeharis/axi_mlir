// func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call(
//   %arg0: memref<1x3x230x230xi32>, 
//   %arg1: memref<64x3x7x7xi32>, 
//   %arg2: memref<1x64x112x112xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<2> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x3x230x230xi32>, memref<64x3x7x7xi32>)
//     outs (%arg2: memref<1x64x112x112xi32>)
//   return

// }

// 49 = 7x7 = 52900
// 9 = 3x3 = 49
// 25 = 5x5 = 12544
// 196=7x7x4 = 158700
// 36=3x3x4 = 147
// 72=3x3x8 = 3136
// 200=5x5x8 = 802816


#conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 158700 + s0 + d1 * 52900 + d2 * 230 + d3)>
#conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 147 + s0 + d1 * 49 + d2 * 7 + d3)>
#conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 3136 + s0 + d1 * 49 + d2 * 7 + d3)>
#conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 802816 + s0 + d1 * 12544 + d2 * 112 + d3)>

func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call(%arg0: memref<1x3x230x230xi32>, %arg1: memref<64x3x7x7xi32>, %arg2: memref<1x64x112x112xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 64 : index
  %c5 = arith.constant 112 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 3 : index
  %c3 = arith.constant 7 : index

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
  %c3_i32 = arith.constant 7 : i32
  %offset2 = accel.sendLiteral %c3_i32  : ( i32 ) -> i32

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 3 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 3, 7, 7] [1, 1, 1, 1] : memref<64x3x7x7xi32> to memref<1x3x7x7xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x3x7x7xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c2_idx = arith.constant 2 : index
        %arg4_new = arith.muli %arg4, %c2_idx : index
        %arg5_new = arith.muli %arg5, %c2_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 3, 7, 7] [1, 1, 1, 1] : memref<1x3x230x230xi32> to memref<1x3x7x7xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x3x7x7xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 64 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x64x112x112xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 112, 112] [1, 1, 1, 1] : memref<1x64x112x112xi32> to memref<1x1x112x112xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x112x112xi32, #conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x3x230x230xi32>, 
  %arg1: memref<64x3x7x7xi32>, 
  %arg2: memref<1x64x112x112xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x3x230x230xi32>, memref<64x3x7x7xi32>)
    outs (%arg2: memref<1x64x112x112xi32>)
  return
}


// func @conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call(
//   %arg0: memref<1x64x58x58xi32>, 
//   %arg1: memref<64x64x3x3xi32>, 
//   %arg2: memref<1x64x56x56xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<1> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x64x58x58xi32>, memref<64x64x3x3xi32>)
//     outs (%arg2: memref<1x64x56x56xi32>)
//   return

// }

// 49 = 7x7 = 3364
// 9 = 3x3 = 9
// 25 = 5x5 = 3136
// 196=7x7x4 = 215296
// 36=3x3x4 = 576
// 72=3x3x8 = 576
// 200=5x5x8 = 200704


#conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 215296 + s0 + d1 * 3364 + d2 * 58 + d3)>
#conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 576 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 576 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 200704 + s0 + d1 * 3136 + d2 * 56 + d3)>

func @conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call(%arg0: memref<1x64x58x58xi32>, %arg1: memref<64x64x3x3xi32>, %arg2: memref<1x64x56x56xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 64 : index
  %c5 = arith.constant 56 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 64 : index
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

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 64 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 64, 3, 3] [1, 1, 1, 1] : memref<64x64x3x3xi32> to memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c1_idx = arith.constant 1 : index
        %arg4_new = arith.muli %arg4, %c1_idx : index
        %arg5_new = arith.muli %arg5, %c1_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 64, 3, 3] [1, 1, 1, 1] : memref<1x64x58x58xi32> to memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 64 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x64x56x56xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 56, 56] [1, 1, 1, 1] : memref<1x64x56x56xi32> to memref<1x1x56x56xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x56x56xi32, #conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x64x58x58xi32>, 
  %arg1: memref<64x64x3x3xi32>, 
  %arg2: memref<1x64x56x56xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x64x58x58xi32>, memref<64x64x3x3xi32>)
    outs (%arg2: memref<1x64x56x56xi32>)
  return
}


// func @conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call(
//   %arg0: memref<1x64x56x56xi32>, 
//   %arg1: memref<128x64x1x1xi32>, 
//   %arg2: memref<1x128x28x28xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<2> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x64x56x56xi32>, memref<128x64x1x1xi32>)
//     outs (%arg2: memref<1x128x28x28xi32>)
//   return

// }

// 49 = 7x7 = 3136
// 9 = 3x3 = 1
// 25 = 5x5 = 784
// 196=7x7x4 = 200704
// 36=3x3x4 = 64
// 72=3x3x8 = 128
// 200=5x5x8 = 100352


#conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 200704 + s0 + d1 * 3136 + d2 * 56 + d3)>
#conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 64 + s0 + d1 * 1 + d2 * 1 + d3)>
#conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 128 + s0 + d1 * 1 + d2 * 1 + d3)>
#conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 100352 + s0 + d1 * 784 + d2 * 28 + d3)>

func @conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call(%arg0: memref<1x64x56x56xi32>, %arg1: memref<128x64x1x1xi32>, %arg2: memref<1x128x28x28xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 128 : index
  %c5 = arith.constant 28 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 64 : index
  %c3 = arith.constant 1 : index

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
  %c3_i32 = arith.constant 1 : i32
  %offset2 = accel.sendLiteral %c3_i32  : ( i32 ) -> i32

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 64 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 64, 1, 1] [1, 1, 1, 1] : memref<128x64x1x1xi32> to memref<1x64x1x1xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x64x1x1xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c2_idx = arith.constant 2 : index
        %arg4_new = arith.muli %arg4, %c2_idx : index
        %arg5_new = arith.muli %arg5, %c2_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 64, 1, 1] [1, 1, 1, 1] : memref<1x64x56x56xi32> to memref<1x64x1x1xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x64x1x1xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 128 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x128x28x28xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 28, 28] [1, 1, 1, 1] : memref<1x128x28x28xi32> to memref<1x1x28x28xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x28x28xi32, #conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x64x56x56xi32>, 
  %arg1: memref<128x64x1x1xi32>, 
  %arg2: memref<1x128x28x28xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x64x56x56xi32>, memref<128x64x1x1xi32>)
    outs (%arg2: memref<1x128x28x28xi32>)
  return
}


// func @conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call(
//   %arg0: memref<1x64x58x58xi32>, 
//   %arg1: memref<128x64x3x3xi32>, 
//   %arg2: memref<1x128x28x28xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<2> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x64x58x58xi32>, memref<128x64x3x3xi32>)
//     outs (%arg2: memref<1x128x28x28xi32>)
//   return

// }

// 49 = 7x7 = 3364
// 9 = 3x3 = 9
// 25 = 5x5 = 784
// 196=7x7x4 = 215296
// 36=3x3x4 = 576
// 72=3x3x8 = 1152
// 200=5x5x8 = 100352


#conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 215296 + s0 + d1 * 3364 + d2 * 58 + d3)>
#conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 576 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 1152 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 100352 + s0 + d1 * 784 + d2 * 28 + d3)>

func @conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call(%arg0: memref<1x64x58x58xi32>, %arg1: memref<128x64x3x3xi32>, %arg2: memref<1x128x28x28xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 128 : index
  %c5 = arith.constant 28 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 64 : index
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

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 64 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 64, 3, 3] [1, 1, 1, 1] : memref<128x64x3x3xi32> to memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c2_idx = arith.constant 2 : index
        %arg4_new = arith.muli %arg4, %c2_idx : index
        %arg5_new = arith.muli %arg5, %c2_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 64, 3, 3] [1, 1, 1, 1] : memref<1x64x58x58xi32> to memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x64x3x3xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 128 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x128x28x28xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 28, 28] [1, 1, 1, 1] : memref<1x128x28x28xi32> to memref<1x1x28x28xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x28x28xi32, #conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x64x58x58xi32>, 
  %arg1: memref<128x64x3x3xi32>, 
  %arg2: memref<1x128x28x28xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x64x58x58xi32>, memref<128x64x3x3xi32>)
    outs (%arg2: memref<1x128x28x28xi32>)
  return
}


// func @conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call(
//   %arg0: memref<1x128x30x30xi32>, 
//   %arg1: memref<128x128x3x3xi32>, 
//   %arg2: memref<1x128x28x28xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<1> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x128x30x30xi32>, memref<128x128x3x3xi32>)
//     outs (%arg2: memref<1x128x28x28xi32>)
//   return

// }

// 49 = 7x7 = 900
// 9 = 3x3 = 9
// 25 = 5x5 = 784
// 196=7x7x4 = 115200
// 36=3x3x4 = 1152
// 72=3x3x8 = 1152
// 200=5x5x8 = 100352


#conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 115200 + s0 + d1 * 900 + d2 * 30 + d3)>
#conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 1152 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 1152 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 100352 + s0 + d1 * 784 + d2 * 28 + d3)>

func @conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call(%arg0: memref<1x128x30x30xi32>, %arg1: memref<128x128x3x3xi32>, %arg2: memref<1x128x28x28xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 128 : index
  %c5 = arith.constant 28 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 128 : index
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

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 128 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 128, 3, 3] [1, 1, 1, 1] : memref<128x128x3x3xi32> to memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c1_idx = arith.constant 1 : index
        %arg4_new = arith.muli %arg4, %c1_idx : index
        %arg5_new = arith.muli %arg5, %c1_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 128, 3, 3] [1, 1, 1, 1] : memref<1x128x30x30xi32> to memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 128 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x128x28x28xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 28, 28] [1, 1, 1, 1] : memref<1x128x28x28xi32> to memref<1x1x28x28xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x28x28xi32, #conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x128x30x30xi32>, 
  %arg1: memref<128x128x3x3xi32>, 
  %arg2: memref<1x128x28x28xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x128x30x30xi32>, memref<128x128x3x3xi32>)
    outs (%arg2: memref<1x128x28x28xi32>)
  return
}


// func @conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call(
//   %arg0: memref<1x128x28x28xi32>, 
//   %arg1: memref<256x128x1x1xi32>, 
//   %arg2: memref<1x256x14x14xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<2> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x128x28x28xi32>, memref<256x128x1x1xi32>)
//     outs (%arg2: memref<1x256x14x14xi32>)
//   return

// }

// 49 = 7x7 = 784
// 9 = 3x3 = 1
// 25 = 5x5 = 196
// 196=7x7x4 = 100352
// 36=3x3x4 = 128
// 72=3x3x8 = 256
// 200=5x5x8 = 50176


#conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 100352 + s0 + d1 * 784 + d2 * 28 + d3)>
#conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 128 + s0 + d1 * 1 + d2 * 1 + d3)>
#conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 256 + s0 + d1 * 1 + d2 * 1 + d3)>
#conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 50176 + s0 + d1 * 196 + d2 * 14 + d3)>

func @conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call(%arg0: memref<1x128x28x28xi32>, %arg1: memref<256x128x1x1xi32>, %arg2: memref<1x256x14x14xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 256 : index
  %c5 = arith.constant 14 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 128 : index
  %c3 = arith.constant 1 : index

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
  %c3_i32 = arith.constant 1 : i32
  %offset2 = accel.sendLiteral %c3_i32  : ( i32 ) -> i32

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 128 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 128, 1, 1] [1, 1, 1, 1] : memref<256x128x1x1xi32> to memref<1x128x1x1xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x128x1x1xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c2_idx = arith.constant 2 : index
        %arg4_new = arith.muli %arg4, %c2_idx : index
        %arg5_new = arith.muli %arg5, %c2_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 128, 1, 1] [1, 1, 1, 1] : memref<1x128x28x28xi32> to memref<1x128x1x1xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x128x1x1xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 256 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x256x14x14xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 14, 14] [1, 1, 1, 1] : memref<1x256x14x14xi32> to memref<1x1x14x14xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x14x14xi32, #conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x128x28x28xi32>, 
  %arg1: memref<256x128x1x1xi32>, 
  %arg2: memref<1x256x14x14xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x128x28x28xi32>, memref<256x128x1x1xi32>)
    outs (%arg2: memref<1x256x14x14xi32>)
  return
}


// func @conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call(
//   %arg0: memref<1x128x30x30xi32>, 
//   %arg1: memref<256x128x3x3xi32>, 
//   %arg2: memref<1x256x14x14xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<2> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x128x30x30xi32>, memref<256x128x3x3xi32>)
//     outs (%arg2: memref<1x256x14x14xi32>)
//   return

// }

// 49 = 7x7 = 900
// 9 = 3x3 = 9
// 25 = 5x5 = 196
// 196=7x7x4 = 115200
// 36=3x3x4 = 1152
// 72=3x3x8 = 2304
// 200=5x5x8 = 50176


#conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 115200 + s0 + d1 * 900 + d2 * 30 + d3)>
#conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 1152 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 2304 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 50176 + s0 + d1 * 196 + d2 * 14 + d3)>

func @conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call(%arg0: memref<1x128x30x30xi32>, %arg1: memref<256x128x3x3xi32>, %arg2: memref<1x256x14x14xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 256 : index
  %c5 = arith.constant 14 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 128 : index
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

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 128 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 128, 3, 3] [1, 1, 1, 1] : memref<256x128x3x3xi32> to memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c2_idx = arith.constant 2 : index
        %arg4_new = arith.muli %arg4, %c2_idx : index
        %arg5_new = arith.muli %arg5, %c2_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 128, 3, 3] [1, 1, 1, 1] : memref<1x128x30x30xi32> to memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x128x3x3xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 256 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x256x14x14xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 14, 14] [1, 1, 1, 1] : memref<1x256x14x14xi32> to memref<1x1x14x14xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x14x14xi32, #conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x128x30x30xi32>, 
  %arg1: memref<256x128x3x3xi32>, 
  %arg2: memref<1x256x14x14xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x128x30x30xi32>, memref<256x128x3x3xi32>)
    outs (%arg2: memref<1x256x14x14xi32>)
  return
}


// func @conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call(
//   %arg0: memref<1x256x16x16xi32>, 
//   %arg1: memref<256x256x3x3xi32>, 
//   %arg2: memref<1x256x14x14xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<1> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x256x16x16xi32>, memref<256x256x3x3xi32>)
//     outs (%arg2: memref<1x256x14x14xi32>)
//   return

// }

// 49 = 7x7 = 256
// 9 = 3x3 = 9
// 25 = 5x5 = 196
// 196=7x7x4 = 65536
// 36=3x3x4 = 2304
// 72=3x3x8 = 2304
// 200=5x5x8 = 50176


#conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 65536 + s0 + d1 * 256 + d2 * 16 + d3)>
#conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 2304 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 2304 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 50176 + s0 + d1 * 196 + d2 * 14 + d3)>

func @conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call(%arg0: memref<1x256x16x16xi32>, %arg1: memref<256x256x3x3xi32>, %arg2: memref<1x256x14x14xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 256 : index
  %c5 = arith.constant 14 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 256 : index
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

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 256 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 256, 3, 3] [1, 1, 1, 1] : memref<256x256x3x3xi32> to memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c1_idx = arith.constant 1 : index
        %arg4_new = arith.muli %arg4, %c1_idx : index
        %arg5_new = arith.muli %arg5, %c1_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 256, 3, 3] [1, 1, 1, 1] : memref<1x256x16x16xi32> to memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 256 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x256x14x14xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 14, 14] [1, 1, 1, 1] : memref<1x256x14x14xi32> to memref<1x1x14x14xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x14x14xi32, #conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x256x16x16xi32>, 
  %arg1: memref<256x256x3x3xi32>, 
  %arg2: memref<1x256x14x14xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x256x16x16xi32>, memref<256x256x3x3xi32>)
    outs (%arg2: memref<1x256x14x14xi32>)
  return
}


// func @conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call(
//   %arg0: memref<1x256x14x14xi32>, 
//   %arg1: memref<512x256x1x1xi32>, 
//   %arg2: memref<1x512x7x7xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<2> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x256x14x14xi32>, memref<512x256x1x1xi32>)
//     outs (%arg2: memref<1x512x7x7xi32>)
//   return

// }

// 49 = 7x7 = 196
// 9 = 3x3 = 1
// 25 = 5x5 = 49
// 196=7x7x4 = 50176
// 36=3x3x4 = 256
// 72=3x3x8 = 512
// 200=5x5x8 = 25088


#conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 50176 + s0 + d1 * 196 + d2 * 14 + d3)>
#conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 256 + s0 + d1 * 1 + d2 * 1 + d3)>
#conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 512 + s0 + d1 * 1 + d2 * 1 + d3)>
#conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 25088 + s0 + d1 * 49 + d2 * 7 + d3)>

func @conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call(%arg0: memref<1x256x14x14xi32>, %arg1: memref<512x256x1x1xi32>, %arg2: memref<1x512x7x7xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 512 : index
  %c5 = arith.constant 7 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 256 : index
  %c3 = arith.constant 1 : index

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
  %c3_i32 = arith.constant 1 : i32
  %offset2 = accel.sendLiteral %c3_i32  : ( i32 ) -> i32

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 256 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 256, 1, 1] [1, 1, 1, 1] : memref<512x256x1x1xi32> to memref<1x256x1x1xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x256x1x1xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c2_idx = arith.constant 2 : index
        %arg4_new = arith.muli %arg4, %c2_idx : index
        %arg5_new = arith.muli %arg5, %c2_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 256, 1, 1] [1, 1, 1, 1] : memref<1x256x14x14xi32> to memref<1x256x1x1xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x256x1x1xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 512 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x512x7x7xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 7, 7] [1, 1, 1, 1] : memref<1x512x7x7xi32> to memref<1x1x7x7xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x7x7xi32, #conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x256x14x14xi32>, 
  %arg1: memref<512x256x1x1xi32>, 
  %arg2: memref<1x512x7x7xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x256x14x14xi32>, memref<512x256x1x1xi32>)
    outs (%arg2: memref<1x512x7x7xi32>)
  return
}


// func @conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call(
//   %arg0: memref<1x256x16x16xi32>, 
//   %arg1: memref<512x256x3x3xi32>, 
//   %arg2: memref<1x512x7x7xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<2> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x256x16x16xi32>, memref<512x256x3x3xi32>)
//     outs (%arg2: memref<1x512x7x7xi32>)
//   return

// }

// 49 = 7x7 = 256
// 9 = 3x3 = 9
// 25 = 5x5 = 49
// 196=7x7x4 = 65536
// 36=3x3x4 = 2304
// 72=3x3x8 = 4608
// 200=5x5x8 = 25088


#conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 65536 + s0 + d1 * 256 + d2 * 16 + d3)>
#conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 2304 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 4608 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 25088 + s0 + d1 * 49 + d2 * 7 + d3)>

func @conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call(%arg0: memref<1x256x16x16xi32>, %arg1: memref<512x256x3x3xi32>, %arg2: memref<1x512x7x7xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 512 : index
  %c5 = arith.constant 7 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 256 : index
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

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 256 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 256, 3, 3] [1, 1, 1, 1] : memref<512x256x3x3xi32> to memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c2_idx = arith.constant 2 : index
        %arg4_new = arith.muli %arg4, %c2_idx : index
        %arg5_new = arith.muli %arg5, %c2_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 256, 3, 3] [1, 1, 1, 1] : memref<1x256x16x16xi32> to memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x256x3x3xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 512 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x512x7x7xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 7, 7] [1, 1, 1, 1] : memref<1x512x7x7xi32> to memref<1x1x7x7xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x7x7xi32, #conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_CPU_NONE_call(
  %arg0: memref<1x256x16x16xi32>, 
  %arg1: memref<512x256x3x3xi32>, 
  %arg2: memref<1x512x7x7xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<2> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x256x16x16xi32>, memref<512x256x3x3xi32>)
    outs (%arg2: memref<1x512x7x7xi32>)
  return
}


// func @conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call(
//   %arg0: memref<1x512x9x9xi32>, 
//   %arg1: memref<512x512x3x3xi32>, 
//   %arg2: memref<1x512x7x7xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<1> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<1x512x9x9xi32>, memref<512x512x3x3xi32>)
//     outs (%arg2: memref<1x512x7x7xi32>)
//   return

// }

// 49 = 7x7 = 81
// 9 = 3x3 = 9
// 25 = 5x5 = 49
// 196=7x7x4 = 41472
// 36=3x3x4 = 4608
// 72=3x3x8 = 4608
// 200=5x5x8 = 25088


#conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 41472 + s0 + d1 * 81 + d2 * 9 + d3)>
#conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 4608 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 4608 + s0 + d1 * 9 + d2 * 3 + d3)>
#conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * 25088 + s0 + d1 * 49 + d2 * 7 + d3)>

func @conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call(%arg0: memref<1x512x9x9xi32>, %arg1: memref<512x512x3x3xi32>, %arg2: memref<1x512x7x7xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 512 : index
  %c5 = arith.constant 7 : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 512 : index
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

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant 512 : i32
  %offset4 = accel.sendLiteral %c4_i32  : ( i32 ) -> i32

  scf.for %arg6 = %c0 to %c1 step %c1 { // B
  scf.for %arg3 = %c0 to %c8 step %c1 { // OC
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, 512, 3, 3] [1, 1, 1, 1] : memref<512x512x3x3xi32> to memref<1x512x3x3xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x512x3x3xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c1_idx = arith.constant 1 : index
        %arg4_new = arith.muli %arg4, %c1_idx : index
        %arg5_new = arith.muli %arg5, %c1_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, 512, 3, 3] [1, 1, 1, 1] : memref<1x512x9x9xi32> to memref<1x512x3x3xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x512x3x3xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant 512 : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<1x512x7x7xi32> to memref<1x1x1x1xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, 7, 7] [1, 1, 1, 1] : memref<1x512x7x7xi32> to memref<1x1x7x7xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x7x7xi32, #conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call_map11>, i32) -> i32

    }
  }
  return
}



func @conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_CPU_NONE_call(
  %arg0: memref<1x512x9x9xi32>, 
  %arg1: memref<512x512x3x3xi32>, 
  %arg2: memref<1x512x7x7xi32>) {
  linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
                            strides = dense<1> : tensor<2xi64>}
    ins (%arg0, %arg1: memref<1x512x9x9xi32>, memref<512x512x3x3xi32>)
    outs (%arg2: memref<1x512x7x7xi32>)
  return
}


