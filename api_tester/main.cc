
#include "mlir/ExecutionEngine/axi/api_v1.h"

#include <iostream>
#include <iomanip>
#include <cstdlib>
 
using namespace std;

 void print_matrix(int rows, int cols, int* matrix){
  cout << "==================================" << endl;
  for(int r=0;r<rows;r++){
    cout << "|";
    for(int c=0;c<cols;c++){
      // cout << matrix[r * cols  + c];
      printf("%-3d",matrix[r * cols  + c]);
      if(c+1<cols) cout << ",";
    }
    cout << "|" << endl;
  }
  cout << "==================================" << endl;
}

void simpleGEMM(int rows, int cols, int depth, int* inputs, int* weights, int* outputs){
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

}

// struct systemC_sigs{
//     sc_clock clk_fast;
//     sc_signal<bool>   sig_reset;
//     sc_fifo<DATA> din1;
//     sc_fifo<DATA> dout1;
//     systemC_sigs(int din1s,  int dout1s): din1("din1_fifo",din1s), dout1("dout1_fifo",dout1s){
//         sc_clock clk_fast("ClkFast", 1, SC_NS);
//     }
// };

// void SysC_Assign(MMAcc *acc, DMA_DRIVER *dmad, systemC_sigs *scs){
//     acc->clock(scs->clk_fast);
//     acc->reset(scs->sig_reset);
//     acc->din1(scs->din1);
//     acc->dout1(scs->dout1);
//     dmad->clock(scs->clk_fast);
//     dmad->reset(scs->sig_reset);
//     dmad->din1(scs->din1);
//     dmad->dout1(scs->dout1);
// }

// MMAcc acc("DUT");
// DMA_DRIVER dm("DMA");
// int DMA_input_buffer[1000];
// int DMA_output_buffer[1000];
// dm.DMA_input_buffer = DMA_input_buffer;
// dm.DMA_output_buffer = DMA_output_buffer;
// struct systemC_sigs scs(1000,1000);
// SysC_Assign(&acc,&dm,&scs);
// dma1.acc = &acc;
// dma1.dmad = &dm;


int main(int argc, char *argv[]){

    int cols = 4;
    int depth = 4;
    int rows = 8;


    int inputs[rows*depth];
    int weights[depth*cols];
    int outputs[cols*rows];
    int accelerated_outputs[cols*rows];

    for(int i=0;i<cols*rows;i++){
        outputs[i]=0;
        accelerated_outputs[i] = 0;
    }

    for(int i=0;i<depth*cols;i++)weights[i]=rand() % 10 + 0;
    for(int i=0;i<rows*depth;i++)inputs[i]=rand() % 10 + 0;

    cout << "Input Matix" << endl;
    print_matrix(rows,depth,inputs);
    cout << "Weight Matix" << endl;
    print_matrix(depth,cols,weights);

    simpleGEMM(rows,cols,depth,inputs,weights,outputs);
    cout << "Correct Results" << endl;
    print_matrix(rows,cols,outputs);



    struct dma dma1;
    unsigned int dims[3];

    dims[0]=rows;
    dims[1]=cols;
    dims[2]=depth;

    dma1.dma_init(0,0,1000,0,1000);
    dma1.dma_copy_to_inbuffer(dims,3,dma1.dmad->input_len);
    
    dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int*>(inputs),rows*depth,dma1.dmad->input_len);
    dma1.dma_copy_to_inbuffer(reinterpret_cast<unsigned int*>(weights),depth*cols,dma1.dmad->input_len);
    dma1.dma_wait_send();
    dma1.dma_copy_from_outbuffer(reinterpret_cast<unsigned int*>(accelerated_outputs),cols*rows,0);

    cout << "Accelerated Results" << endl;
    print_matrix(rows,cols,accelerated_outputs);
}