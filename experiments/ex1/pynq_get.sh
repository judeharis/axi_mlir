#!/bin/bash

axi4mlir_projroot=/mnt/Crucial/WorkspaceB/AXI4MLIR/axi4mlir/
arm_libs_dir=$axi4mlir_projroot/builds/llvm-project/build-runner-arm/lib
board_user=tester1
board_hostname=92.237.73.36
ex=ex1_pynq
bins_dir=bins
libs_dir=./$ex/libs
arm_app_dir=/home/axi4mlir/tester1/experiments/


# Attempt to receive results from the board
echo "If results folder exists, try to copy it to the host system..."
rsync -r -av -e 'ssh -p 2202' $board_user@$board_hostname:$arm_app_dir/$ex/results ./$ex/