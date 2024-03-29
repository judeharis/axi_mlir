#include "conv_helper.h"
#include "mlir/ExecutionEngine/axi/api_v1.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <vector>
using namespace std;

#define IHW 9
#define IC 8
#define FHW 5
#define OC 2
#define B 1
#define ST 1

void reset(conv2d_params p, int *arg0, int *arg1, int *arg2) {
  for (int n = 0; n < p.b; n++) {
    for (int c = 0; c < p.ic; c++) {
      for (int h = 1; h < p.ih - 1; h++) {
        for (int w = 1; w < p.iw - 1; w++) {
          arg0[(n * p.ic * p.ih * p.iw) + (c * p.ih * p.iw) + (h * p.iw) + w] =
              h;
        }
      }
    }
  }

  for (int o = 0; o < p.oc; o++) {
    for (int c = 0; c < p.ic; c++) {
      for (int h = 0; h < p.fh; h++) {
        for (int w = 0; w < p.fw; w++) {
          arg1[(o * p.ic * p.fh * p.fw) + (c * p.fh * p.fw) + (h * p.fw) + w] =
              1;
        }
      }
    }
  }

  for (int i = 0; i < (p.b * p.oh * p.ow * p.oc); i++)
    arg2[i] = 0;
}

void dump_in(conv2d_params p, int *arg0, int *arg1) {
  cout << "Input" << endl;
  cout << "======================" << endl;
  for (int n = 0; n < p.b; n++) {
    for (int c = 0; c < p.ic; c++) {
      for (int h = 0; h < p.ih; h++) {
        for (int w = 0; w < p.iw; w++) {
          cout << arg0[(n * p.ic * p.ih * p.iw) + (c * p.ih * p.iw) +
                       (h * p.iw) + w]
               << ",";
        }
        cout << endl;
      }
      cout << endl;
    }
  }
  cout << "======================" << endl;

  cout << "Filters" << endl;
  cout << "======================" << endl;
  for (int o = 0; o < p.oc; o++) {
    for (int c = 0; c < p.ic; c++) {
      for (int h = 0; h < p.fh; h++) {
        for (int w = 0; w < p.fw; w++) {
          cout << arg1[(o * p.ic * p.fh * p.fw) + (c * p.fh * p.fw) +
                       (h * p.fw) + w]
               << ",";
        }
        cout << endl;
      }
      cout << endl;
    }
  }
  cout << "======================" << endl;
}

void dump_out(conv2d_params p, int *arg2) {
  cout << "Output" << endl;
  cout << "======================" << endl;
  for (int n = 0; n < p.b; n++) {
    for (int c = 0; c < p.oc; c++) {
      for (int h = 0; h < p.oh; h++) {
        for (int w = 0; w < p.ow; w++) {
          cout << arg2[(n * p.oh * p.ow * p.oc) + (h * p.ow * p.oc) +
                       (w * p.oc) + c]
               << ",";
        }
        cout << endl;
      }
      cout << endl;
    }
  }
  cout << "======================" << endl;
}

// void coreKernel(int *arg0, int *arg1, int *arg2, dma *dma1, conv2d_params *p,
//                 int b, int oh, int ow, int oc) {
//   unsigned int *dma_inbuffer = dma1->dma_get_inbuffer();
//   int data_len = 0;
//   int offset = p->ic * p->fh * p->fw;

//   uint32_t opcode = 15;
//   dma_inbuffer[data_len++] = opcode;
//   for (int ic = 0; ic < p->ic; ic++) {
//     for (int fh = 0; fh < p->fh; fh++) {
//       for (int fw = 0; fw < p->fw; fw++) {
//         int h = oh + fh;
//         int w = ow + fw;
//         dma_inbuffer[data_len] = arg0[(b * p->ic * p->ih * p->iw) +
//                                       (ic * p->ih * p->iw) + (h * p->iw) +
//                                       w];
//         dma_inbuffer[offset + data_len++] =
//             arg1[(oc * p->ic * p->fh * p->fw) + (ic * p->fh * p->fw) +
//                  (fh * p->fw) + fw];
//       }
//     }
//   }
//   data_len += offset;
//   dma1->dma_start_send(data_len, 0);
//   dma1->dma_wait_send();
//   dma1->dma_start_recv(1, 0);
//   dma1->dma_wait_recv();
//   unsigned int *dma_outbuffer = dma1->dma_get_outbuffer();
//   arg2[(b * p->oh * p->ow * p->oc) + (oh * p->ow * p->oc) + (ow * p->oc) +
//        oc] += dma_outbuffer[0];
// }

int main(int argc, char *argv[]) {

  LOG("=========================");
  LOG("ACC: Conv_v3");
  LOG("Tiling Strat: 1");
  LOG("=========================");

  int b = B;
  int ih = IHW;
  int iw = IHW;
  int ic = IC;
  int fh = FHW;
  int fw = FHW;
  int oc = OC;
  int stride = ST;
  int oh = ih - (fh - stride);
  int ow = iw - (fw - stride);

  struct conv2d_params p = {b, ih, iw, ic, fh, fw, oc, oh, ow};
  p.validate();
  auto arg0 = new int[b * ih * iw * ic];
  auto arg1 = new int[fh * fw * ic * oc];
  auto arg2 = new int[b * oh * ow * oc];
  auto arg3 = new int[b * oh * ow * oc];

  // C++ Conv2D implementation
  reset(p, arg0, arg1, arg3);
  dump_in(p, arg0, arg1);
  simpleConv2D(p, arg0, arg1, arg3);
  dump_out(p, arg3);

  // C++ wit ACC Conv2D implementation
  // Init DMA + ACC + reset output
  reset(p, arg0, arg1, arg2);
  struct dma dma1;
#ifndef REAL
  dma1.dma_init(0, 0, 1000, 0, 1000);
#else
  dma1.dma_init(0x40400000, 0x16000000, 65536, 0x16400000, 65536);
#endif

  // Pre-config filter height and width
  unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
  uint32_t opcode = 32;
  dma_inbuffer[0] = opcode;
  dma_inbuffer[1] = fh;
  dma1.dma_start_send(2, 0);
  dma1.dma_wait_send();

  // coreKernel(arg0, arg1, arg2, &dma1, &p, b, oh, ow, oc);

  // unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
  // Start Tiling
  for (int b = 0; b < p.b; b++) { // N 
    for (int oc = 0; oc < p.oc; oc++) {  // F

      // Send IC parameter
      uint32_t opcode = 16;
      dma_inbuffer[0] = opcode;
      dma_inbuffer[1] = p.ic;
      dma1.dma_start_send(2, 0);
      dma1.dma_wait_send();

      // Send Filter data for current OC
      int data_len = 0;
      opcode = 1;
      dma_inbuffer[data_len++] = opcode;
      for (int ic = 0; ic < p.ic; ic++) {  // C 
        for (int fh = 0; fh < p.fh; fh++) { // H
          for (int fw = 0; fw < p.fw; fw++) { // W
            dma_inbuffer[data_len++] =
                arg1[(oc * p.ic * p.fh * p.fw) + (ic * p.fh * p.fw) +
                     (fh * p.fw) + fw];
          }
        }
      }
      dma1.dma_start_send(data_len, 0);
      dma1.dma_wait_send();

      // Send Input data for current OC + Compute and Save inside accelerator
      data_len = 0;
      for (int oh = 0; oh < p.oh; oh++) { 
        for (int ow = 0; ow < p.ow; ow++) {
          uint32_t opcode = 6 + 64;
          data_len = 0;
          dma_inbuffer[data_len++] = opcode;
          for (int ic = 0; ic < p.ic; ic++) { // C
            for (int fh = 0; fh < p.fh; fh++) { // H
              for (int fw = 0; fw < p.fw; fw++) { // W
                int h = oh + fh;
                int w = ow + fw;
                dma_inbuffer[data_len++] =
                    arg0[(b * p.ic * p.ih * p.iw) + (ic * p.ih * p.iw) +
                         (h * p.iw) + w];
              }
            }
          }
          dma1.dma_start_send(data_len, 0);
          dma1.dma_wait_send();
        }
      }

      // Send Recieve all outputs for current OC
      data_len = 0;
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
          arg2[(b * p.oh * p.ow * p.oc) + (oh * p.ow * p.oc) + (ow * p.oc) +
               oc] += dma_outbuffer[out_index++];
        }
      }
    }
  }
  dma1.dma_free();
  dump_out(p, arg2);
}

// (SF (SI C AC)+ RC)+ : Send Filter, (Send Input,Compute, Accumulate on Acc),
// Recieve Output Kernel

//  ((SF ((SI C AC)+)+ RC)+)+ -- filter S

// unsigned int *dma_inbuffer = dma1.dma_get_inbuffer();
// int data_len = 0;
// for (int fh = 0; fh < p.fh; fh++) {
//   for (int fw = 0; fw < p.fw; fw++) {
//     int h = oh + fh;
//     int w = ow + fw;
//     for (int ic = 0; ic < p.ic; ic++) {
//       dma_inbuffer[data_len++] =
//           arg0[(b * p.ic * p.ih * p.iw) + (ic * p.ih * p.iw) +
//                (h * p.iw) + w];
//       dma_inbuffer[data_len++] =
//           arg1[(oc * p.ic * p.fh * p.fw) + (ic * p.fh * p.fw) +
//                (fh * p.fw) + fw];
//     }
//   }
// }
// dma1.dma_start_send(data_len, 0);
// dma1.dma_wait_send();
// dma1.dma_start_recv(1, 0);
// dma1.dma_wait_recv();
// unsigned int *dma_outbuffer = dma1.dma_get_outbuffer();
// arg2[(b * p.oh * p.ow * p.oc) + (oh * p.ow * p.oc) + (ow * p.oc) +
//      oc] += dma_outbuffer[0];
