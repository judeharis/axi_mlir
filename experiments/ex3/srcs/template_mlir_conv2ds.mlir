// func @${MLIR_CALL}(
//   %arg0: memref<${B}x${IC}x${IHW}x${IHW}xi32>, 
//   %arg1: memref<${OC}x${IC}x${FHW}x${FHW}xi32>, 
//   %arg2: memref<${B}x${OC}x${OHW}x${OHW}xi32>) {
//   linalg.conv_2d_nchw_fchw {dilations = dense<1> : tensor<2xi64>,
//                             strides = dense<${ST}> : tensor<2xi64>}
//     ins (%arg0, %arg1: memref<${B}x${IC}x${IHW}x${IHW}xi32>, memref<${OC}x${IC}x${FHW}x${FHW}xi32>)
//     outs (%arg2: memref<${B}x${OC}x${OHW}x${OHW}xi32>)
//   return

// }

// 49 = 7x7 = ${IHWxIHW}
// 9 = 3x3 = ${FHWxFHW}
// 25 = 5x5 = ${OHWxOHW}
// 196=7x7x4 = ${IHWxIHWxIC}
// 36=3x3x4 = ${FHWxFHWxIC}
// 72=3x3x8 = ${FHWxFHWxOC}
// 200=5x5x8 = ${OHWxOHWxOC}


#${MLIR_CALL}_map8 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * ${IHWxIHWxIC} + s0 + d1 * ${IHWxIHW} + d2 * ${IHW} + d3)>
#${MLIR_CALL}_map9 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * ${FHWxFHWxIC} + s0 + d1 * ${FHWxFHW} + d2 * ${FHW} + d3)>
#${MLIR_CALL}_map10 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * ${FHWxFHWxOC} + s0 + d1 * ${FHWxFHW} + d2 * ${FHW} + d3)>
#${MLIR_CALL}_map11 = affine_map<(d0, d1, d2, d3)[s0] -> (d0 * ${OHWxOHWxOC} + s0 + d1 * ${OHWxOHW} + d2 * ${OHW} + d3)>

func @${MLIR_CALL}(%arg0: memref<${B}x${IC}x${IHW}x${IHW}xi32>, %arg1: memref<${OC}x${IC}x${FHW}x${FHW}xi32>, %arg2: memref<${B}x${OC}x${OHW}x${OHW}xi32>) {
  %c1 = arith.constant 1 : index
  %c8 = arith.constant ${OC} : index
  %c5 = arith.constant ${OHW} : index
  %c0 = arith.constant 0 : index
  %c4 = arith.constant ${IC} : index
  %c3 = arith.constant ${FHW} : index

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
  %c3_i32 = arith.constant ${FHW} : i32
  %offset2 = accel.sendLiteral %c3_i32  : ( i32 ) -> i32

  // // Send IC parameter
  // uint32_t opcode = 16;
  // dma_inbuffer[0] = opcode;
  // dma_inbuffer[1] = p.ic;
  // dma1.dma_start_send(2, 0);
  // dma1.dma_wait_send();
  %c16_i32 = arith.constant 16 : i32
  %offset3 = accel.sendLiteral %c16_i32  : ( i32 ) -> i32
  %c4_i32 = arith.constant ${IC} : i32
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
    %1 = memref.subview %arg1[%arg3, 0, 0, 0] [1, ${IC}, ${FHW}, ${FHW}] [1, 1, 1, 1] : memref<${OC}x${IC}x${FHW}x${FHW}xi32> to memref<1x${IC}x${FHW}x${FHW}xi32, #${MLIR_CALL}_map9>
    %c0_i32 = arith.constant 0 : i32
    %offset6 = accel.send %1, %c0_i32 : (memref<1x${IC}x${FHW}x${FHW}xi32, #${MLIR_CALL}_map9>, i32) -> i32


    scf.for %arg4 = %c0 to %c5 step %c1 { // OH
      scf.for %arg5 = %c0 to %c5 step %c1 { // OW
        // uint32_t opcode = 6 + 64;
        // data_len = 0;
        // dma_inbuffer[data_len++] = opcode;
        %c70_i32 = arith.constant 70 : i32
        %offset7 = accel.sendLiteral %c70_i32  : ( i32 ) -> i32

        // JUDE, this subview must get adjusted arg4,arg5
        %c${ST}_idx = arith.constant ${ST} : index
        %arg4_new = arith.muli %arg4, %c${ST}_idx : index
        %arg5_new = arith.muli %arg5, %c${ST}_idx : index

        //for C,H,W to send input slice
        %0 = memref.subview %arg0[0, 0, %arg4_new, %arg5_new] [1, ${IC}, ${FHW}, ${FHW}] [1, 1, 1, 1] : memref<${B}x${IC}x${IHW}x${IHW}xi32> to memref<1x${IC}x${FHW}x${FHW}xi32, #${MLIR_CALL}_map8>
        %offset8 = accel.send %0, %c0_i32 : (memref<1x${IC}x${FHW}x${FHW}xi32, #${MLIR_CALL}_map8>, i32) -> i32

        // // data_len = 0;
        // // opcode = 8;
        // // dma_inbuffer[0] = opcode;
        // // dma1.dma_start_send(1, 0);
        // // dma1.dma_wait_send();
        // %c8_i32 = arith.constant ${OC} : i32
        // %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
        
        // // dma1.dma_start_recv(p.oh * p.ow, 0);
        // // dma1.dma_wait_recv();
        // %2 = memref.subview %arg2[0, %arg3, %arg4, %arg5] [1, 1, 1, 1] [1, 1, 1, 1] : memref<${B}x${OC}x${OHW}x${OHW}xi32> to memref<1x1x1x1xi32, #${MLIR_CALL}_map11>
        // %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x1x1xi32, #${MLIR_CALL}_map11>, i32) -> i32
      }
    }


    %c8_i32 = arith.constant 8 : i32
    %offset9 = accel.sendLiteral %c8_i32  : ( i32 ) -> i32
    
    // dma1.dma_start_recv(p.oh * p.ow, 0);
    // dma1.dma_wait_recv();
    %2 = memref.subview %arg2[0, %arg3, 0, 0] [1, 1, ${OHW}, ${OHW}] [1, 1, 1, 1] : memref<${B}x${OC}x${OHW}x${OHW}xi32> to memref<1x1x${OHW}x${OHW}xi32, #${MLIR_CALL}_map11>
    %offset10 = accel.recv %2, %c0_i32 : (memref<1x1x${OHW}x${OHW}xi32, #${MLIR_CALL}_map11>, i32) -> i32

    }
  }
  return
}


