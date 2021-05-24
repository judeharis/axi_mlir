
#include <iostream>


#ifdef AXI_DMA
  #include "includes/axi_lib.h"
  #include <fcntl.h>
#else
  #include <systemc.h>
  #include "includes/accelerator.sc.h"
  #include "includes/dma_engine.sc.h"
#endif

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

int main(int argc, char** argv) {

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


#ifdef AXI_DMA
  //DMA Initialization

  int dh = open("/dev/mem", O_RDWR | O_SYNC); // Open /dev/mem which represents the whole physical memory
  void *dma_mm = mmap(NULL, 65535, PROT_READ | PROT_WRITE, MAP_SHARED, dh, 0x40400000); // DMA Memory map AXI Lite register block

  void *dma_input_buffer_mm  = mmap(NULL, 4194304, PROT_READ | PROT_WRITE, MAP_SHARED, dh, 0x16000000); // MM DMA Input Buffer
  void *dma_output_buffer_mm = mmap(NULL, 4194304, PROT_READ, MAP_SHARED, dh, 0x16400000);  // MM DMA Output Buffer
  unsigned int* dma0 =reinterpret_cast<unsigned int*> (dma_mm);  // cast DMA Registers to int
  int* dma_in =reinterpret_cast<int*> (dma_input_buffer_mm); // cast DMA Input Buffer to int
  int* dma_out =reinterpret_cast<int*> (dma_output_buffer_mm); // cast DMA Input Buffer to int



  dma_set<int>(dma0, S2MM_CONTROL_REGISTER, 4);
  dma_set<int>(dma0, MM2S_CONTROL_REGISTER, 4);
  dma_set<int>(dma0, S2MM_CONTROL_REGISTER, 0);
  dma_set<int>(dma0, MM2S_CONTROL_REGISTER, 0);
  dma_set<int>(dma0, S2MM_DESTINATION_ADDRESS, 0x16400000); // Define DMA Input Buffer Address
  dma_set<int>(dma0, MM2S_START_ADDRESS, 0x16000000); // Define DMA Input Buffer Address
  dma_set<int>(dma0, S2MM_CONTROL_REGISTER, 0xf001);
  dma_set<int>(dma0, MM2S_CONTROL_REGISTER, 0xf001);
  //End of DMA Initialization



  int input_len = 0;
  //Copy Input to Input DMA_Buffer
  //GEMM shape metadata
  dma_in[input_len++] = rows;
  dma_in[input_len++] = cols;
  dma_in[input_len++] = depth;

  //Input & Weight matrices
  for(int i=0;i<rows*depth;i++) dma_in[input_len++] = inputs[i];
  for(int i=0;i<depth*cols;i++) dma_in[input_len++] = weights[i];


  //Set available output buffer size (Memory Allocated is 4194304)
  dma_set<int>(dma0, S2MM_DESTINATION_ADDRESS, 0x16400000); // Define DMA Input Buffer Address
  dma_set<int>(dma0, S2MM_LENGTH,16384);



  //Starts DRAM to ACC transfer by setting the length (in bytes) to transfer
  dma_set<int>(dma0, MM2S_START_ADDRESS, 0x16000000); // Define DMA Input Buffer Address
  dma_set<int>(dma0, MM2S_LENGTH, input_len*4);


  //Blocking Wait DRAM to ACC transfer to complete
  dma_mm2s_sync<int>(dma0);

  //Blocking Wait ACC to DRAM transfer to complete marked by TLAST signal (Acc need to finish and send back all GEMM results)
  dma_s2mm_sync<int>(dma0);

  //Copies Results from Output DMA_Buffer
  for(int i=0;i<cols*rows;i++)accelerated_outputs[i] = dma_out[i];



#else
  //SystemC Init
  sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);
  sc_report_handler::set_actions( SC_ID_LOGIC_X_TO_BOOL_, SC_LOG);
  sc_report_handler::set_actions( SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_LOG);

  sc_clock clk_fast("ClkFast", 1, SC_NS);
  sc_signal<bool>    sig_reset;
  sc_fifo <DATA>			din1("din1_fifo",16384);
  sc_fifo <DATA>			dout1("dout1_fifo",16384);

  //DUT
  Gemm ge("DUT");
  ge.clock(clk_fast);
  ge.reset(sig_reset);
  ge.dout1(dout1);
  ge.din1(din1);

  //DMA Engine
  DMA dm("DMA");
  dm.clock(clk_fast);
  dm.reset(sig_reset);
  dm.dout1(dout1);
  dm.din1(din1);
  //End of SystemC Init


  //Copy Input to Input DMA_Buffer
  //GEMM shape metadata
  dm.DMA_input_buffer[dm.input_len++] = rows;
  dm.DMA_input_buffer[dm.input_len++] = cols;
  dm.DMA_input_buffer[dm.input_len++] = depth;

  //Input & Weight matrices
  for(int i=0;i<rows*depth;i++) dm.DMA_input_buffer[dm.input_len++] = inputs[i];
  for(int i=0;i<depth*cols;i++) dm.DMA_input_buffer[dm.input_len++] = weights[i];

  //Start Simulation of DMA Engine & Accelerator
  sc_start();

  //Returns here after sc_pause() --- Copies Results from Output DMA_Buffer
  for(int i=0;i<cols*rows;i++)accelerated_outputs[i] = dm.DMA_output_buffer[i];

#endif

  cout << "Accelerated Results" << endl;
  print_matrix(rows,cols,accelerated_outputs);













    














    return(0);
}
