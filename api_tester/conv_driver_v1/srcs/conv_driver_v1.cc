#include "conv_config.h"
#include "conv_helper.h"
#include "conv_v3_t1.h"
#include "mlir/ExecutionEngine/axi/api_v1.h"
#include "mlir_utils.h"
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <vector>
using namespace std;

int testCorrect(int *arg1, int *arg2, int size) {
  bool equal = true;
  for (int i = 0; i < size; i++) {
    if (arg1[i] != arg2[i]) {
      equal = false;
      break;
    }
  }
  if (!equal)
    std::cout << "  FAILED" << std::endl;
  else
    std::cout << "  PASSED" << std::endl;
  return equal == true ? 0 : -1;
}

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
  cout << "======================" << endl;
  cout << "Output" << endl;
  cout << "======================" << endl;
  for (int n = 0; n < p.b; n++) {
    for (int c = 0; c < p.oc; c++) {
      for (int h = 0; h < p.oh; h++) {
        for (int w = 0; w < p.ow; w++) {
          cout << arg2[(n * p.oc * p.oh * p.ow) + (c * p.oh * p.ow) +
                       (h * p.ow) + w]
               << ",";
        }
        cout << endl;
      }
      cout << endl;
    }
  }
  cout << "======================" << endl;
}

int main() {

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

  // print problem size
  cout << "Problem size: " << endl;
  cout << "B: " << b << endl;
  cout << "IH: " << ih << endl;
  cout << "IW: " << iw << endl;
  cout << "IC: " << ic << endl;
  cout << "FH: " << fh << endl;
  cout << "FW: " << fw << endl;
  cout << "OC: " << oc << endl;
  cout << "OH: " << oh << endl;
  cout << "OW: " << ow << endl;

  struct conv2d_params p = {b, ih, iw, ic, fh, fw, oc, oh, ow, stride, pad};
  p.validate();
  auto arg0 = new int[b * ic * ih * iw]();
  auto arg1 = new int[oc * ic * fh * fw]();
  auto arg2 = new int[b * oc * oh * ow]();
  auto arg3 = new int[b * oc * oh * ow]();

#if TEST
  reset(p, arg0, arg1, arg3);
  simpleConv2D(p, arg0, arg1, arg3);
#endif

#ifdef RUNCPP
  reset(p, arg0, arg1, arg2);
  v3_Fs(arg0, arg1, arg2);
#if DBG
  printf("Executed MANUAL version on accelerator\n");
#endif
#elif RUNMLIR
  // ==========================================================
  // MLIR without C interface
  reset(p, arg0, arg1, arg2);
  // clang-format off
    MLIRCONV2DCALL((int *)arg0, (int *)arg0, 0, p.b, p.ic, p.ih, p.iw,
                                              p.ic*p.ih*p.iw, p.ih*p.iw, p.iw, 1,
                 (int *)arg1, (int *)arg1, 0, p.oc, p.ic, p.fh, p.fw,
                                              p.ic*p.fh*p.fw, p.fh*p.fw, p.fw, 1,
                 (int *)arg2, (int *)arg2, 0, p.b, p.oc, p.oh, p.ow,
                                              p.oc*p.oh*p.ow, p.oh*p.ow, p.ow, 1);
#if DBG
  printf("Executed MLIR version on accelerator\n");
#endif
#endif

// Prints matrices and problem size
#if DBG
  printf("Problem ");
  printf("B: %d, IH: %d, IW: %d, IC: %d, FH: %d, FW: %d, OC: %d, OH: %d, OW: %d\n",
         p.b, p.ih, p.iw, p.ic, p.fh, p.fw, p.oc, p.oh, p.ow);
  printf("finished execution. Printing matrices: \n");
  dump_in(p, arg0, arg1);
  dump_out(p,arg2);
  dump_out(p,arg3);
#endif

int ret = 0;
// Compare with C++ MM implementation
#if TEST
  ret = testCorrect(arg2, arg3, ow*oh*oc);
#if DBG

if (ret != 0)
{
  printf("======================\n");
  printf("Expected: \n");
  dump_out(p,arg3);
  
  printf("Failed: Output and golden differ. \n");
}
#endif
#endif

  free(arg0);
  free(arg1);
  free(arg2);
  free(arg3);
  return ret;
}