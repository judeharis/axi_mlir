# Benchmark
This folder can be cloned to the PYNQ board to run all benchmarks required.
Before doing so please run the gather script to gather all the binaries and libraries that is required to be on board into this folder. 

Ensure the following Directory exists on the PYNQ board
xilinx/Development/axi4mlir

Make sure you are running this inside the container.
```shell
$ ./gather.sh
```

Once gathered we can simply send all sync the benchmark folder to our PYNQ boards. (Edit script to configure device address/host)
```shell
$ ./send.sh
```

To run the matmuldriver on the PYNQ board, run the following on the board (root is needed)
```shell
$ cd /home/xilinx/Development/axi4mlir/benchmark
$ ./run.sh
```

The command above will generate several csv files inside the `perf_output/` folder and
a concatenated file inside the `results/` folder with hostname and timestamp.
The contents of the concatenated file can be copy, pasted and split by commas inside the google spreadsheet

Note, to mimic the benchmark steps it is adviseble to kill the jupyter server
that runs on the background.

-  This can be achieved by running `sudo htop` and `F9` and `SIGTERM` jupyter