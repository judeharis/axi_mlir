#include "accelerator.sc.h"


void ACCNAME::Recv() {
	ic.write(0);
	read_si.write(1);
  wait();
  unsigned int start_count=0;
  while (1) {
		read_si.write(4);
		opcode packet(din1.read().data);

		if (packet.set_channels) {
			int tic = din1.read().data;
			int fs_ic = fs * tic;
			int nic = fs_ic/49;
			ic.write(nic);
			fs.write(fs_ic/nic);
		}

		if (packet.set_filter_size) {
			int nfs = din1.read().data;
			fs.write(nfs*nfs);
		}


    if (packet.read_inputs) {
			for (int c = 0; c < ic; c++) {
#pragma HLS pipeline
				for (int hw = 0; hw < fs; hw++) {
						inputs[hw][c] = din1.read().data;
				}
			}
    }

		read_si.write(5);
		if (packet.read_fliters) {
			for (int c = 0; c < ic; c++) {
#pragma HLS pipeline
				for (int hw = 0; hw < fs; hw++) {
					filters[hw][c] = din1.read().data;
				}
			}
		}

		read_si.write(6);
    if (packet.compute_outputs) {
      compute.write(true);
      wait();
    }

    wait();
		while (compute)
			wait();

		if(packet.save_output)output_size.write(output_size+1);

    if (packet.send_outputs) {
      wait();
      send.write(true);
    }

    while (send)
      wait();

  }
}


void ACCNAME::Compute() {
	int ic_acc[49];

#pragma HLS array_partition variable=ic_acc complete dim=0


	compute_si.write(0);
  wait();
  while (1) {
  	compute_si.write(1);
    while (!compute)
      wait();

    compute_si.write(2);
    wait();

		for (int hw = 0; hw < 49; hw++) {
#pragma HLS unroll
				ic_acc[hw]=0;
		}

    for (int c = 0; c < ic; c++) {
#pragma HLS pipeline
			for (int hw = 0; hw < H*W; hw++) {
					int x = inputs[hw][c];
					int y = filters[hw][c];
					ic_acc[hw] += mul_int32(x,y);
			}
		}

		for (int hw = 0; hw < fs; hw++) {
				output[output_size]+=ic_acc[hw];
		}

    compute_si.write(3);
    wait();
    compute.write(false);
    wait();
  }
}

int ACCNAME::mul_int32(int x, int y) {
	return x * y;
}

void ACCNAME::Send() {
	output_size.write(0);
	send_si.write(0);
  wait();
  while (1) {
  	send_si.write(1);
    while (!send)
      wait();
    send_si.write(2);

    for (int i = 0; i<output_size;i++){
  		DATA d;
  		d.data = output[0];
  		bool last = (i+1 == output_size);
  		d.tlast = last;
  		dout1.write(d);

    }
    wait();

    for (int i = 0; i<output_size;i++){
#pragma HLS unroll
  		output[i]=0;
    }
    output_size.write(0);

    send_si.write(3);
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


