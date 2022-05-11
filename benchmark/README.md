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

## TODO : Update to collect results into results folder 
## TODO : Create script to run all the different accelerators