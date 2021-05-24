#include "includes/accelerator.sc.h"

void Gemm::Read(){

    DATA last = {0,1};
    while(1){
        rows = din1.read().data;
        cols = din1.read().data;
        depth = din1.read().data;

        for(int i=0;i<rows*depth;i++)inputs[i] = din1.read().data;
        for(int i=0;i<depth*cols;i++)weights[i] = din1.read().data;


        for(int i=0;i<rows;i++){
            for(int w=0;w<cols;w++){
                int acc = 0;
                for(int d=0;d<depth;d++){
                int x = inputs[i*depth+d];
                int y =  weights[d*cols + w];
                acc+=  x*y;
                }
                outputs[i*cols+w] = acc;
            }
        }


        for(int i=0;i<cols*rows;i++){
            DATA d;
            d.tlast = false;
            d.data = outputs[i];
            dout1.write(d);
        }

        dout1.write(last);
        wait();
    }

}
