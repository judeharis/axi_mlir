#include "accelerator.sc.h"

void ACCNAME::Recv() {
  ic.write(0);
  wait();
  while (1) {
    opcode packet(din1.read().data);
    if (packet.set_channels) {
      int tic = din1.read().data;
      int fs_ic = fs * tic;
      fs_ic = (fs_ic + 49 - (fs_ic % 49));
      int nic = fs_ic / 49;
      // ic.write(nic);
      // fs.write(fs_ic / nic);
      ic.write(tic);
    }

    if (packet.set_filter_size) {
      int nfs = din1.read().data;
      fs.write(nfs * nfs);
    }

    if (packet.read_inputs) {
      for (int c = 0; c < ic; c++) {
        HLSPRAGMA(HLS pipeline)
        for (int hw = 0; hw < fs; hw++) {
          inputs[hw][c] = din1.read().data;
          cout << inputs[hw][c] << ",";
        }
        cout << endl;
      }
      cout << endl;
    }

    if (packet.read_fliters) {
      for (int c = 0; c < ic; c++) {
        HLSPRAGMA(HLS pipeline)
        for (int hw = 0; hw < fs; hw++) {
          filters[hw][c] = din1.read().data;
        }
      }
    }

    if (packet.compute_outputs) {
      compute.write(true);
      wait();
    }

    wait();
    while (compute)
      wait();

    if (packet.save_output)
      output_size.write(output_size + 1);

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
  HLSPRAGMA(HLS array_partition variable = ic_acc complete dim = 0)

  wait();
  while (1) {
    while (!compute)
      wait();

    for (int hw = 0; hw < 49; hw++) {
      HLSPRAGMA(HLS unroll)
      ic_acc[hw] = 0;
    }

    for (int c = 0; c < ic; c++) {
      HLSPRAGMA(HLS pipeline)
      for (int hw = 0; hw < H * W; hw++) {
        int x = inputs[hw][c];
        int y = filters[hw][c];
        ic_acc[hw] += mul_int32(x, y);
      }
    }

		cout << "output_size: " << output_size << endl;
    for (int hw = 0; hw < fs; hw++) {
      cout << ic_acc[hw] << ",";
      output[output_size] += ic_acc[hw];
    }
    cout << endl << output[output_size] << endl;
		cout << endl;

    wait();
    compute.write(false);
    wait();
  }
}

int ACCNAME::mul_int32(int x, int y) { return x * y; }

void ACCNAME::Send() {
  output_size.write(0);
  wait();
  while (1) {
    while (!send)
      wait();

    for (int i = 0; i < output_size; i++) {
      DATA d;
      d.data = output[i];
      bool last = (i + 1 == output_size);
      d.tlast = last;
      dout1.write(d);
    }
    wait();

    for (int i = 0; i < output_size; i++) {
      HLSPRAGMA(HLS unroll)
      output[i] = 0;
    }
    output_size.write(0);
    send.write(false);
    wait();
  }
}
