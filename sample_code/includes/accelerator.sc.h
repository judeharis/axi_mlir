#ifndef GEMM_H
#define GEMM_H

#include <systemc.h>


typedef struct _DATA{
  sc_uint<32> data;
  bool        tlast;

  inline friend ostream& operator << (ostream& os, const _DATA &v){
    cout << "data&colon; " << v.data << " tlast: " << v.tlast;
    return os;
  }
} DATA;

SC_MODULE(Gemm) {

    sc_in<bool> clock;
    sc_in <bool>  reset;


    sc_int<32> inputs[4096];
    sc_int<32> weights[4096];
    sc_int<32> outputs[4096];

    sc_fifo_in<DATA> din1;
    sc_fifo_out<DATA> dout1;

    int rows;
    int cols;
    int depth;



    void Read();

    SC_HAS_PROCESS(Gemm);

 Gemm(sc_module_name name_):sc_module(name_){

    SC_CTHREAD(Read,clock.pos());
    reset_signal_is(reset,true);


#pragma HLS RESOURCE variable=din1 core=AXI4Stream metadata="-bus_bundle S_AXIS_DATA1" port_map={{din1_0 TDATA} {din1_1 TLAST}}
#pragma HLS RESOURCE variable=dout1 core=AXI4Stream metadata="-bus_bundle M_AXIS_DATA1" port_map={{dout1_0 TDATA} {dout1_1 TLAST}}
#pragma HLS RESET variable=reset
  }


};
#endif