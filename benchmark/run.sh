#!/bin/bash

# Exit if a single commmand fails
set -e

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
  driver-matmul-m64_n64_k64-MEM-acc4
)

for INPUT in ${AppArray[@]}; do

  perf stat -r 5 -x, -o $POUTDIR/perf-results-tmp.csv -e $PEVENTS_ALL $APPDIR/$INPUT-app
  #perf stat -r 5 -e $PEVENTS_ALL $APPDIR/$INPUT-app

  # Process the CSV file and concatenate into a final output
  # TODO
  mv $POUTDIR/perf-results-tmp.csv $POUTDIR/perf-results-$INPUT.csv

  # Delay to let the board "cool"
  sleep 0.1
done



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