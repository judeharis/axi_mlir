#!/bin/bash

# Exit if a single commmand fails
set -e -o pipefail

# Change limit
ulimit -s 65536
# ulimit -s 131072

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/axi4mlir/tester1/experiments/ex4_pynq/libs/:/home/axi4mlir/tester1/experiments/ex4_pynq/bins/

BIT_DIR="/home/axi4mlir/tester1/bitmaps"
POUTDIR=perf_output
APPDIR=bins

mkdir -p $POUTDIR
mkdir -p $APPDIR

PEVENTS_HW=branch-instructions,branch-misses,cache-references,cache-misses,cpu-cycles
PEVENTS_SW=context-switches,page-faults,task-clock
PEVENTS_L1=L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses
PEVENTS_LLC=LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores
PEVENTS_ALL=$PEVENTS_HW,$PEVENTS_SW,$PEVENTS_L1,duration_time

BITSTREAM="${BIT_DIR}/MM_16x16_v4.bit"
if test -f "$BITSTREAM"; then
    ./load_bitstream.py $BITSTREAM
else
    echo "Bitstream $BITSTREAM does not exist"
    exit 1
fi


rm -f ./perf_output/*

source ./bins/appslist.sh

for INPUT in ${AppArray[@]}; do
    if test -f "$APPDIR/$INPUT"; then
        echo "Running $INPUT ..."
        perf stat -r 5 -x, -o $POUTDIR/perf-results-tmp.csv -e $PEVENTS_ALL $APPDIR/$INPUT

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
mkdir -p results
TIMESTAMP_RAW=$(date +%Y_%m_%d-%H:%M:%S-%Z)
TIMESTAMP=${TIMESTAMP_RAW// /_}
./prepare_results.py perf_output > results/results-${HOSTNAME}-${TIMESTAMP}.csv
cp -f results/results-${HOSTNAME}-${TIMESTAMP}.csv results/results-latest.csv

chown -R tester1:tester1 *

rm ./perf_output/*

