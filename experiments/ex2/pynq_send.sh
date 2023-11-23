#!/bin/bash

axi4mlir_projroot=/mnt/Crucial/WorkspaceB/AXI4MLIR/axi4mlir/
arm_libs_dir=$axi4mlir_projroot/builds/llvm-project/build-runner-arm/lib
board_user=tester1
board_hostname=92.237.73.36
ex=ex2_pynq
bins_dir=bins
libs_dir=./$ex/libs
arm_app_dir=/home/axi4mlir/tester1/experiments/

mkdir -p $libs_dir
cp $arm_libs_dir/*.so.15git  $libs_dir/

rm -f /$ex/results/results-latest.csv
rsync -r -avz -e 'ssh -p 2202' ./$ex $board_user@$board_hostname:$arm_app_dir/
