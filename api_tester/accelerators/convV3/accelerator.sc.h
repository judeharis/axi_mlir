#ifndef CONV2D_H
#define CONV2D_H

#include "../../../llvm-project/mlir/include/mlir/ExecutionEngine/axi/accelerators/dma_engine.sc.h"
#include <systemc.h>

#ifndef __SYNTHESIS__
#define DWAIT(x) wait(x)
#define HLSPRAGMA(X)
#else
#define DWAIT(x)
#define HLSPRAGMA(X) Pragma(#X)
#endif

#define H 7   // Filter H 1,3,5,7
#define W 7   // Filter W 1,3,5,7
#define C 128 // Input C

#define PRAGMA(X) _Pragma(#X)



#define HWC_AXI4LiteS(name, signame)                                           \
  PRAGMA(HLS resource core = AXI4LiteS metadata = "-bus_bundle hwc" variable = \
             name##_##signame)

#define HWC_PragGroup(name)                                                    \
  HWC_AXI4LiteS(name, sts) HWC_AXI4LiteS(name, co) HWC_AXI4LiteS(name, so)

#define HWC_Define(name)                                                       \
  sc_in<unsigned int> name##_sts;                                              \
  sc_signal<unsigned int> name##_si;                                           \
  sc_out<unsigned int> name##_co;                                              \
  sc_out<unsigned int> name##_so;                                              \
  unsigned int name##_cycles;

#define ACCNAME CONV_V3
#ifdef VERBOSE_ACC
#define ALOG(x) std::cout << x << std::endl
#else
#define ALOG(x)
#endif

// OP-Code Stuct
// 0000 : 0 = NOP;
// 0001 : 1 = read_fliters;
// 0010 : 2 = read_inputs;
// 0011 : 3 = read_fliters -> read_inputs;
// 0100 : 4 = compute_outputs;
// 0101 : 5 = read_fliters -> compute_outputs;
// 0110 : 6 = read_inputs -> compute_outputs;
// 0111 : 7 = read_fliters -> read_inputs -> compute_outputs;

// 1000 : 8 = send_outputs;
// 1001 : 9 = read_fliters -> send_outputs;
// 1010 : 10 = read_inputs -> send_outputs;
// 1011 : 11 = read_fliters -> read_inputs -> send_outputs;
// 1100 : 12 = compute_outputs -> send_outputs;
// 1101 : 13 = read_fliters -> compute_outputs -> send_outputs;
// 1110 : 14 = read_inputs -> compute_outputs -> send_outputs;
// 1111 : 15 = read_fliters -> read_inputs -> compute_outputs -> send_outputs;

// 10000 : 16 = set_channels;
// 100000 : 32 = set_filter_size;
// 1000000 : 64 = save_output;

struct opcode {
  unsigned int packet;
  bool read_fliters;
  bool read_inputs;
  bool compute_outputs;
  bool send_outputs;
  bool set_channels;
  bool set_filter_size;
  bool save_output;

  opcode(sc_uint<32> _packet) {
    ALOG("OPCODE: " << _packet);
    ALOG("Time: " << sc_time_stamp());
    packet = _packet;
    read_fliters = _packet.range(0, 0);
    read_inputs = _packet.range(1, 1);
    compute_outputs = _packet.range(2, 2);
    send_outputs = _packet.range(3, 3);
    set_channels = _packet.range(4, 4);
    set_filter_size = _packet.range(5, 5);
    save_output = _packet.range(6, 6);
  }
};

SC_MODULE(ACCNAME) {
  sc_in<bool> clock;
  sc_in<bool> reset;

  sc_int<32> inputs[H * W][C];
  sc_int<32> filters[H * W][C];
  sc_int<32> output[2048];
  sc_fifo_in<DATA> din1;
  sc_fifo_out<DATA> dout1;

#ifndef __SYNTHESIS__
  sc_signal<bool, SC_MANY_WRITERS> compute;
  sc_signal<bool, SC_MANY_WRITERS> send;
  sc_signal<bool, SC_MANY_WRITERS> save_output;
  sc_signal<int, SC_MANY_WRITERS> output_size;
#else
  sc_signal<bool> compute;
  sc_signal<bool> send;
  sc_signal<bool> save_output;
  sc_signal<int> output_size;
#endif

  //  sc_in<unsigned int> start;
  //  sc_in<bool> reset_start;
  //	sc_in<bool> hwc_reset;
  // HWC_Define(read);
  // HWC_Define(compute);
  // HWC_Define(send);

  sc_signal<int> fs;
  sc_signal<int> ic;

  void Recv();

  void Compute();

  void Send();

  int mul_int32(int, int);

  void all_counters();

  void print_profile();

  SC_HAS_PROCESS(ACCNAME);

  ACCNAME(sc_module_name name_)
      : sc_module(
            name_) // @suppress("Class members should be properly initialized")
  {
    SC_CTHREAD(Recv, clock.pos());
    reset_signal_is(reset, true);

    SC_CTHREAD(Compute, clock.pos());
    reset_signal_is(reset, true);

    SC_CTHREAD(Send, clock.pos());
    reset_signal_is(reset, true);

    //    SC_CTHREAD(all_counters, clock.pos());
    //    reset_signal_is(reset, true);

    // clang-format off
#ifdef __SYNTHESIS__
#pragma HLS RESOURCE variable=din1 core=AXI4Stream metadata="-bus_bundle S_AXIS_DATA1" port_map={{din1_0 TDATA} {din1_1 TLAST}}
#pragma HLS RESOURCE variable=dout1 core=AXI4Stream metadata="-bus_bundle M_AXIS_DATA1" port_map={{dout1_0 TDATA} {dout1_1 TLAST}}
#pragma HLS RESET variable=reset

#pragma HLS array_partition variable=inputs complete dim=1
#pragma HLS array_partition variable=filters complete dim=1
#endif
    // clang-format on

    //#pragma HLS resource core=AXI4LiteS metadata="-bus_bundle acc"
    // variable=start #pragma HLS resource core=AXI4LiteS metadata="-bus_bundle
    // acc" variable=reset_start #pragma HLS resource core=AXI4LiteS
    // metadata="-bus_bundle hwc" variable=hwc_reset
    // HWC_PragGroup(read)
    // HWC_PragGroup(compute)
    // HWC_PragGroup(send)
  }
};

#endif
