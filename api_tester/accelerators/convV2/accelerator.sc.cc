#include "accelerator.sc.h"


void ACCNAME::Recv() {
	ic.write(0);
	// read_si.write(1);
  wait();
  unsigned int start_count=0;
  while (1) {
		// read_si.write(4);
		opcode packet(din1.read().data);

		if (packet.set_channels) {
			int nic = din1.read().data;
			ic.write(nic);
			// read_co.write(ic);
		}


    if (packet.read_inputs) {
			for (int c = 0; c < ic; c++) {
#pragma HLS pipeline
				for (int h = 0; h < H; h++) {
					for (int w = 0; w < W; w++) {
						inputs[h][w][c] = din1.read().data;
					}
				}
			}
    }

		// read_si.write(5);
		if (packet.read_fliters) {
			for (int c = 0; c < ic; c++) {
#pragma HLS pipeline
				for (int h = 0; h < H; h++) {
					for (int w = 0; w < W; w++) {
						filters[h][w][c] = din1.read().data;
					}
				}
			}
		}

		// read_si.write(6);
    if (packet.compute_outputs) {
      compute.write(true);
      wait();
    }
    wait();
		while (compute)
			wait();

    if (packet.send_outputs) {
      wait();
      send.write(true);
    }

    while (send)
      wait();

  }
}

void ACCNAME::Compute() {
	int ic_acc[4];
	// compute_si.write(0);
  wait();
  while (1) {
  	// compute_si.write(1);
    while (!compute)
      wait();

    // compute_si.write(2);
    wait();

    for (int c = 0; c < 4; c++) ic_acc[c]=0;

    for (int c = 0; c < ic; c++) {
#pragma HLS unroll factor =4
#pragma HLS pipeline
			for (int h = 0; h < H; h++) {
				for (int w = 0; w < W; w++) {
					int x = inputs[h][w][c];
					int y = filters[h][w][c];
					ic_acc[c%4] += mul_int32(x,y);
				}
			}
		}
		output[0]+=ic_acc[0]+ic_acc[1]+ic_acc[2]+ic_acc[3];
		// read_so.write(ic_acc[0]);
    // compute_si.write(3);
    wait();
    compute.write(false);
    wait();
  }
}

int ACCNAME::mul_int32(int x, int y) {
	return x * y;
}

void ACCNAME::Send() {
	// send_si.write(0);
  wait();
  while (1) {
  	// send_si.write(1);
    while (!send)
      wait();
    // send_si.write(2);

		DATA d;
		d.tlast = true;
		d.data = output[0];
		dout1.write(d);
		wait();
		output[0]=0;

    // send_si.write(3);
    send.write(false);
    wait();
  }
}

//void ACCNAME::all_counters(){
//	wait();
//	while(true){
//		{
//#pragma HLS LATENCY max=0 min=0
//#pragma HLS protocol fixed
//			HWC_Func(read)
//			HWC_Func(compute)
//			HWC_Func(send)
//		}
//	}
//}


