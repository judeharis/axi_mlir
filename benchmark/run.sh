#!/bin/bash

# Exit if a single commmand fails
set -e

# Change limit
ulimit -s 65536

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/xilinx/Development/axi4mlir/benchmark/libs/

POUTDIR=perf_output
APPDIR=bins

mkdir -p $POUTDIR
mkdir -p $APPDIR

PEVENTS_HW=branch-instructions,branch-misses,cache-references,cache-misses,cpu-cycles
PEVENTS_SW=context-switches,page-faults,task-clock
PEVENTS_L1=L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses
PEVENTS_LLC=LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores
PEVENTS_ALL=$PEVENTS_HW,$PEVENTS_SW,$PEVENTS_L1,$PEVENTS_LLC,duration_time

# LOAD correct bitstream
# TODO

# A "-app" will be appented to create the final app name

./load_bitstream.py /home/xilinx/pynq/overlays/axi4mlir/hmm_acc_4x4v1.bit

declare -a AppArray=(
  driver-matmul-m128_n128_k128-CPU-accNONE
  driver-matmul-m128_n128_k128-L1-acc4
  driver-matmul-m128_n128_k128-L2-acc4
  driver-matmul-m128_n128_k128-MANUAL-acc4
  driver-matmul-m128_n128_k128-MEM-acc4
  driver-matmul-m16_n16_k16-CPU-accNONE
  driver-matmul-m16_n16_k16-L1-acc4
  driver-matmul-m16_n16_k16-L2-acc4
  driver-matmul-m16_n16_k16-MANUAL-acc4
  driver-matmul-m16_n16_k16-MEM-acc4
  driver-matmul-m256_n256_k256-CPU-accNONE
  driver-matmul-m256_n256_k256-L1-acc4
  driver-matmul-m256_n256_k256-L2-acc4
  driver-matmul-m256_n256_k256-MANUAL-acc4
  driver-matmul-m256_n256_k256-MEM-acc4
  driver-matmul-m32_n32_k32-CPU-accNONE
  driver-matmul-m32_n32_k32-L1-acc4
  driver-matmul-m32_n32_k32-L2-acc4
  driver-matmul-m32_n32_k32-MANUAL-acc4
  driver-matmul-m32_n32_k32-MEM-acc4
  driver-matmul-m4_n4_k4-CPU-accNONE
  driver-matmul-m4_n4_k4-L1-acc4
  driver-matmul-m4_n4_k4-L2-acc4
  driver-matmul-m4_n4_k4-MANUAL-acc4
  driver-matmul-m4_n4_k4-MEM-acc4
  # driver-matmul-m512_n512_k512-CPU-accNONE
  # driver-matmul-m512_n512_k512-L1-acc4
  # driver-matmul-m512_n512_k512-L2-acc4
  # driver-matmul-m512_n512_k512-MANUAL-acc4
  # driver-matmul-m512_n512_k512-MEM-acc4
  driver-matmul-m64_n64_k64-CPU-accNONE
  driver-matmul-m64_n64_k64-L1-acc4
  driver-matmul-m64_n64_k64-L2-acc4
  driver-matmul-m64_n64_k64-MANUAL-acc4
  driver-matmul-m64_n64_k64-MEM-acc4
  driver-matmul-m8_n8_k8-CPU-accNONE
  driver-matmul-m8_n8_k8-L1-acc4
  driver-matmul-m8_n8_k8-L2-acc4
  driver-matmul-m8_n8_k8-MANUAL-acc4
  driver-matmul-m8_n8_k8-MEM-acc4
)

for INPUT in ${AppArray[@]}; do

  echo "Running $INPUT-app"
  perf stat -r 5 -x, -o $POUTDIR/perf-results-tmp.csv -e $PEVENTS_ALL $APPDIR/$INPUT-app
  #perf stat -r 5 -e $PEVENTS_ALL $APPDIR/$INPUT-app

  # Process the CSV file
  mv $POUTDIR/perf-results-tmp.csv $POUTDIR/perf-results-$INPUT.csv

  # Delay to let the board "cool"
  sleep 0.1
done
  
# Process alls CSV files and concatenate into a final output
mkdir -p results
TIMESTAMP_RAW=`date +%c`
TIMESTAMP=${TIMESTAMP_RAW// /_}
./prepare_results.py perf_output > results/results-${HOSTNAME}-${TIMESTAMP}.csv

chown -R xilinx:xilinx *

# Ignore this for now. Just an example on how to permute multiple options

# declare -a StringArray=(
#   "pynq_tiling1_4x4v1"
# )

# declare -a ArgArray=(
#   "20_28_32"
#   "60_72_80"
# )

# # Iterate the string array using for loop
# for ARGCONCAT in ${ArgArray[@]}; do
#   for INPUT in ${StringArray[@]}; do

#     #ARGCONCAT="${ARG// /_}"
#     ARG="${ARGCONCAT//_/ }"

#     perf stat -r 5 -x, -o $POUTDIR/perf-results-$INPUT-$ARGCONCAT.csv -e $PEVENTS_ALL $APPDIR/$INPUT $ARG
#     sleep 0.1

#   done
# done