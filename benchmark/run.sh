#!/bin/bash

# Exit if a single commmand fails
set -e -o pipefail

# Change limit
ulimit -s 65536
# ulimit -s 131072

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/xilinx/Development/axi4mlir/benchmark/libs/

BIT_DIR="/home/xilinx/pynq/overlays/axi4mlir-mm-2023-04-25"
POUTDIR=perf_output
APPDIR=bins

mkdir -p $POUTDIR
mkdir -p $APPDIR

PEVENTS_HW=branch-instructions,branch-misses,cache-references,cache-misses,cpu-cycles
PEVENTS_SW=context-switches,page-faults,task-clock
PEVENTS_L1=L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses
PEVENTS_LLC=LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores
PEVENTS_ALL=$PEVENTS_HW,$PEVENTS_SW,$PEVENTS_L1,duration_time

# Used by both MLIR MATMUL library and final app
declare -a AccelSizeArray=(
    "4"
    "8"
    "16"
)

declare -a ProblemDimArray=(
    "16"
    "32"
    "64"
    "128"
    "256"
    # "512"
)

declare -a StrategyArray=(
    # "MEM"
    # "L2"
    # "L1"
    "ACC"
    # "CPU"
    # "MAN"
)

declare -a AccelTypeArray=(
  v1
  v2
  v3
)


for ACCEL_SIZE in ${AccelSizeArray[@]}; do
for ACCEL_TYPE in ${AccelTypeArray[@]}; do
  BITSTREAM=""

  if [ $ACCEL_TYPE == "v1" ]; then
    # BITSTREAM="/home/xilinx/pynq/overlays/axi4mlir_maps/mm${ACCEL_SIZE}x${ACCEL_SIZE}_v1_highv1_nostatus.bit"
    BITSTREAM="${BIT_DIR}/MM_${ACCEL_SIZE}x${ACCEL_SIZE}_v1.bit"
  elif [ $ACCEL_TYPE == "v2" ]; then
    # BITSTREAM="/home/xilinx/pynq/overlays/axi4mlir_maps/mm_acc_${ACCEL_SIZE}x${ACCEL_SIZE}v2.bit"
    BITSTREAM="${BIT_DIR}/MM_${ACCEL_SIZE}x${ACCEL_SIZE}_v2.bit"
  elif [ $ACCEL_TYPE == "v3" ]; then
    # BITSTREAM="/home/xilinx/pynq/overlays/axi4mlir_maps/mm_acc_${ACCEL_SIZE}x${ACCEL_SIZE}v3.bit"
    BITSTREAM="${BIT_DIR}/MM_${ACCEL_SIZE}x${ACCEL_SIZE}_v3.bit"
  fi

  if test -f "$BITSTREAM"; then
    ./load_bitstream.py $BITSTREAM
  else
    echo "Bitstream $BITSTREAM does not exist"
    exit 1
  fi

for S in ${StrategyArray[@]}; do
for D in ${ProblemDimArray[@]}; do

# No problem with invalid filenames exist because they will be tested
# declare -a AppArray=(
# # driver-matmul-m${D}_n${D}_k${D}-MANUAL-acc${ACCEL_SIZE}
# # driver-matmul-m${D}_n${D}_k${D}-accNONE
# )

if [ $ACCEL_TYPE == "v1" ]; then
  declare -a AppArray=(
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v1_Ns
  )
elif [ $ACCEL_TYPE == "v2" ]; then
  declare -a AppArray=(
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v2_Ns
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v2_As
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v2_Bs
  )
elif [ $ACCEL_TYPE == "v3" ]; then
  declare -a AppArray=(
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v3_Ns
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v3_As
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v3_Bs
    driver-matmul-m${D}_n${D}_k${D}-ACC-acc${ACCEL_SIZE}_v3_Cs
  )
fi


for INPUT in ${AppArray[@]}; do

  if test -f "$APPDIR/$INPUT-app"; then
    echo "Running $INPUT-app"
    perf stat -r 5 -x, -o $POUTDIR/perf-results-tmp.csv -e $PEVENTS_ALL $APPDIR/$INPUT-app
    #perf stat -r 5 -e $PEVENTS_ALL $APPDIR/$INPUT-app

    # Process the CSV file
    mv $POUTDIR/perf-results-tmp.csv $POUTDIR/perf-results-$INPUT.csv

    # Delay to let the board "cool"
    sleep 0.1
  else
    echo "WARNING: File $INPUT-app does not exist"
  fi
done # End of INPUT loop

done # End of D loop
done # End of S loop
done # End of ACCEL_TYPE loop
done # End of ACCEL_SIZE loop
  
# Process alls CSV files and concatenate into a final output
mkdir -p results
TIMESTAMP_RAW=`date +%c`
TIMESTAMP=${TIMESTAMP_RAW// /_}
./prepare_results.py perf_output > results/results-${HOSTNAME}-${TIMESTAMP}.csv
cp results/results-${HOSTNAME}-${TIMESTAMP}.csv results/results-latest.csv

chown -R xilinx:xilinx *

rm ./perf_output/*


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