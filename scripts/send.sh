#!/bin/bash

# Local to Remote: rsync [OPTION]... -e ssh [SRC]... [USER@]HOST:DEST

board_user=xilinx
board_hostname=tul

source_dir=output

axi4mlir_projroot=/working_dir
arm_libs_dir=$axi4mlir_projroot/builds/llvm-project/build-runner-arm/lib
arm_app_dir=/home/xilinx/Development/axi4mlir

rsync -av -e ssh $source_dir/libmlir_mockaxi_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_mockaxi_runner_utils.so.15git
rsync -av -e ssh $source_dir/libmlir_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_runner_utils.so.15git
rsync -av -e ssh $source_dir/libmlir_axi_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_axi_runner_utils.so.15git
rsync -av -e ssh $source_dir/libmlir_c_runner_utils.so.15git $board_user@$board_hostname:$arm_libs_dir/libmlir_c_runner_utils.so.15git
rsync -av -e ssh $source_dir/libaxi_api_v1.so.15git $board_user@$board_hostname:$arm_libs_dir/libaxi_api_v1.so.15git
rsync -av -e ssh $source_dir/app $board_user@$board_hostname:$arm_app_dir/app