
#include "conv_config.h"
#include "conv_helper.h"
#include "mlir/ExecutionEngine/axi/api_v1.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <vector>
using namespace std;

void v3_Fs(int *input, int *filter, int *output) {
#if DBG
  printf("==============================\n");
  printf("ACC on file: %s\n", __FILE__);
  printf("=-----------------------=\n");
#endif

  // Init DMA + ACC
#ifdef SYSC_T
  struct dma dma1;
  dma1.dma_init(0, 0, 65536, 0, 65536);
#else
  struct dma dma1;
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
#endif

  int b = B;
  int ih = IHW;
  int iw = IHW;
  int ic = IC;
  int fh = FHW;
  int fw = FHW;
  int oc = OC;
  int stride = ST;
  int pad = 0;
  int oh = (((ih - fh + 2 * pad) / stride) + 1);
  int ow = (((iw - fw + 2 * pad) / stride) + 1);
  struct conv2d_params p(b, ih, iw, ic, fh, fw, oc, oh, ow, stride, pad);
  // printf("b: %d, ih: %d, iw: %d, ic: %d, fh: %d, fw: %d, oc: %d, oh: %d, "
  //        "ow:%d, stride: %d, pad: %d\n",
  //        p.b, p.ih, p.iw, p.ic, p.fh, p.fw, p.oc, p.oh, p.ow, p.stride,
  //        p.padding);

  // Pre-config filter height and width
  unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
  uint32_t opcode = 32;
  dma_inbuffer[0] = opcode;
  dma_inbuffer[1] = fh;
  dma1.dma_start_send(2, 0);
  dma1.dma_wait_send();
  // Send IC parameter
  opcode = 16;
  dma_inbuffer[0] = opcode;
  dma_inbuffer[1] = p.ic;
  dma1.dma_start_send(2, 0);
  dma1.dma_wait_send();

  // Start Tiling
  for (int b = 0; b < p.b; b++) {       // N
    for (int oc = 0; oc < p.oc; oc++) { // F

      // Send Filter data for current OC
      int data_len = 0;
      opcode = 1;
      dma_inbuffer[data_len++] = opcode;
      for (int ic = 0; ic < p.ic; ic++) {     // C
        for (int fh = 0; fh < p.fh; fh++) {   // H
          for (int fw = 0; fw < p.fw; fw++) { // W
            int fdex = (oc * p.ic * p.fh * p.fw) + (ic * p.fh * p.fw) +
                       (fh * p.fw) + fw;
            dma_inbuffer[data_len++] =
                filter[(oc * p.ic * p.fh * p.fw) + (ic * p.fh * p.fw) +
                       (fh * p.fw) + fw];
          }
        }
      }

      // dma1.dma_start_send(data_len, 0);
      // dma1.dma_wait_send();

      // Send Input data for current OC + Compute and Save inside accelerator
      data_len = 0;
      for (int oh = 0; oh < p.oh; oh++) {
        for (int ow = 0; ow < p.ow; ow++) {
          uint32_t opcode = 6 + 64;
          data_len = 0;
          dma_inbuffer[data_len++] = opcode;
          for (int ic = 0; ic < p.ic; ic++) {     // C
            for (int fh = 0; fh < p.fh; fh++) {   // H
              for (int fw = 0; fw < p.fw; fw++) { // W
                int h = (oh * stride) + fh;
                int w = (ow * stride) + fw;
                dma_inbuffer[data_len++] =
                    input[(b * p.ic * p.ih * p.iw) + (ic * p.ih * p.iw) +
                          (h * p.iw) + w];
              }
            }
          }
          dma1.dma_start_send(data_len, 0);
          dma1.dma_wait_send();
        }
      }
      // Send Recieve all outputs for current OC
      opcode = 8;
      dma_inbuffer[0] = opcode;
      dma1.dma_start_send(1, 0);
      dma1.dma_wait_send();
      dma1.dma_start_recv(p.oh * p.ow, 0);
      dma1.dma_wait_recv();
      unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();

      int out_index = 0;
      for (int oh = 0; oh < p.oh; oh++) {
        for (int ow = 0; ow < p.ow; ow++) {
          output[(b * p.oc * p.oh * p.ow) + (oc * p.oh * p.ow) + (oh * p.ow) +
                 ow] += dma_outbuffer[out_index++];
        }
      }
    }
  }
  dma1.dma_free();
}

// (SF (SI C AC)+ RC)+ : Send Filter, (Send Input,Compute, Accumulate on Acc),
// Recieve Output Kernel
