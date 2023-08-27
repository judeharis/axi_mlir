#ifndef CONV_HELPER
#define CONV_HELPER

#include <assert.h>
struct conv2d_params {
  int b;  // batch
  int ih; // input height
  int iw; // input width
  int ic; // input channels / shared with filters

  int fh; // filter height
  int fw; // filter column
  int oc; // output channel

  int oh; // output height
  int ow; // output width

  // int padding[4];
  // int strides[2];
  // int dil[2];

  void validate(){
    assert(ih > 0);
    assert(iw > 0);
    assert(ic > 0);
    assert(fh > 0);
    assert(fw > 0);
    assert(oc > 0);
    assert(oh > 0);
    assert(ow > 0);

  };
};


void simpleConv2D(conv2d_params p, int *inputs, int *filters, int *outputs) {

  for (int b = 0; b < p.b; b++) {
    for (int oh = 0; oh < p.oh; oh++) {
      for (int ow = 0; ow < p.ow; ow++) {
        for (int oc = 0; oc < p.oc; oc++) {

          for (int fh = 0; fh < p.fh; fh++) {
            for (int fw = 0; fw < p.fw; fw++) {
              for (int ic = 0; ic < p.ic; ic++) {

                int h = oh + fh;
                int w = ow + fw;
                // int inp = inputs[b][h][w][ic];
                // int inp = inputs[(b * p.ih * p.iw * p.ic) + (h * p.iw * p.ic)
                // +
                //                  (w * p.ic) + ic];
                int inp = inputs[(b * p.ic * p.ih * p.iw) + (ic * p.ih * p.iw) +
                                 (h * p.iw) + w];

                // int wgt = filters[fh][fw][ic][oc];
                // int wgt = filters[(fh * p.fw * p.ic * p.oc) +
                //                   (fw * p.ic * p.oc) + (ic * p.oc) + oc];
                int wgt = filters[(oc * p.ic * p.fh * p.fw) +
                                  (ic * p.fh * p.fw) + (fh * p.fw) + fw];

                // int inp_buffer_size = fh * fw * ic;
                // int wgt_buffer_size = fh * fw * ic;
                // int out_buffer_size = fh * fw * ic;

                int prod = inp * wgt;
                // outputs[b][oh][ow][oc] += prod;
                outputs[(b * p.oh * p.ow * p.oc) + (oh * p.ow * p.oc) +
                        (ow * p.oc) + oc] += prod;
              }
            }
          }
        }
      }
    }
  }
}

#endif // CONV_HELPER