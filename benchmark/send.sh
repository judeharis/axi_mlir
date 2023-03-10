#!/bin/bash

# Local to Remote: rsync [OPTION]... -e ssh [SRC]... [USER@]HOST:DEST

if [ "$HOSTNAME" = WE40997 ]; then
  board_user=xilinx
  board_hostname=tul
elif [ "$HOSTNAME" = AORUS-W ]; then
  board_user=xilinx
  board_hostname=tul
elif [ "$HOSTNAME" = jude-MS-7B79 ]; then
  board_user=xilinx
  board_hostname=192.168.0.17
else
  echo "Hostname not recognized. Exiting..."
  exit 0
fi

bins_dir=bins
libs_dir=libs

axi4mlir_projroot=/working_dir
arm_app_dir=/home/xilinx/Development/axi4mlir

# rsync -av -e ssh $bins_dir/libmlir_mockaxi_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_mockaxi_runner_utils.so.15git
# rsync -av -e ssh $bins_dir/libmlir_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_runner_utils.so.15git
# rsync -av -e ssh $bins_dir/libmlir_axi_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_axi_runner_utils.so.15git
# rsync -av -e ssh $bins_dir/libmlir_c_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_c_runner_utils.so.15git
# rsync -av -e ssh $bins_dir/libaxi_api_v1.so.15git $board_user@$board_hostname:$arm_libs_dir/libaxi_api_v1.so.15git
# rsync -av -e ssh $bins_dir/libmlirmatmuls.so $board_user@$board_hostname:$arm_libs_dir/libmlirmatmuls.so
# rsync -av -e ssh $source_dir/matmuldriver-app $board_user@$board_hostname:$arm_app_dir/matmuldriver-app

rsync -r -av -e ssh ../benchmark $board_user@$board_hostname:$arm_app_dir/

# Attempt to receive results from the board
echo "If results folder exists, try to copy it to the host system..."
rsync -r -av -e ssh $board_user@$board_hostname:$arm_app_dir/benchmark/results .