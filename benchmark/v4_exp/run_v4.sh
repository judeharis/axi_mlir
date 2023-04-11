#!/bin/bash

# Exit if a single commmand fails
set -e -o pipefail

# Change limit
ulimit -s 65536
# ulimit -s 131072

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/xilinx/Development/axi4mlir/benchmark/v4_exp/libs_v4/

BIT_DIR="/home/xilinx/pynq/overlays/axi4mlir-mm-2023-03-31"
POUTDIR=perf_output_v4
APPDIR=bins_v4

mkdir -p $POUTDIR
mkdir -p $APPDIR

PEVENTS_HW=branch-instructions,branch-misses,cache-references,cache-misses,cpu-cycles
PEVENTS_SW=context-switches,page-faults,task-clock
PEVENTS_L1=L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses
PEVENTS_LLC=LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores
PEVENTS_ALL=$PEVENTS_HW,$PEVENTS_SW,$PEVENTS_L1,duration_time

declare -a AccelTypeArray=(
    v4
)

BITSTREAM="${BIT_DIR}/MM_16x16_v4.bit"
# sudo ../load_bitstream.py /home/xilinx/pynq/overlays/axi4mlir-mm-2023-03-31/MM_16x16_v4.bit
if test -f "$BITSTREAM"; then
    ../load_bitstream.py $BITSTREAM
else
    echo "Bitstream $BITSTREAM does not exist"
    exit 1
fi


rm ./perf_output_v4/*

source ./appslist.sh

for INPUT in ${AppArray[@]}; do
    if test -f "$APPDIR/$INPUT"; then
        echo "Running $INPUT ..."
        perf stat -r 5 -x, -o $POUTDIR/perf-results-tmp.csv -e $PEVENTS_ALL $APPDIR/$INPUT
        # $APPDIR/$INPUT
        #perf stat -r 5 -e $PEVENTS_ALL $APPDIR/$INPUT-app

        # Process the CSV file
        mv $POUTDIR/perf-results-tmp.csv $POUTDIR/perf-results-$INPUT.csv

        # Delay to let the board "cool"
        echo "... finished $INPUT"
        sleep 0.1
    else
        echo "WARNING: File $INPUT does not exist"
    fi
done # End of INPUT loop

# Process alls CSV files and concatenate into a final output
mkdir -p results_v4
# TODO: change timestamp to something that sorts automatically
# use the date command to get a timestamp that sorts automatically
# like this: 2019-03-20 15:00:00 UTC
TIMESTAMP_RAW=$(date +%Y_%m_%d-%H:%M:%S-%Z)
TIMESTAMP=${TIMESTAMP_RAW// /_}
./prepare_results_v4.py perf_output_v4 >results_v4/results-${HOSTNAME}-${TIMESTAMP}.csv
cp -f results_v4/results-${HOSTNAME}-${TIMESTAMP}.csv results_v4/results-latest.csv

chown -R xilinx:xilinx *

rm ./perf_output_v4/*

# -----------------------------------------
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
