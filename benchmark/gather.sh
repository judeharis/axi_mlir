#!/bin/bash

if [ "$HOSTNAME" = WE40997 ]; then
  axi4mlir_projroot=/home/nico/Development/axi4mlir/
else
  axi4mlir_projroot=/mnt/UDrive/UWorkspace/AXI4MLIR/axi4mlir/
fi

arm_libs_dir=$axi4mlir_projroot/builds/llvm-project/build-runner-arm/lib
arm_app_dir=$axi4mlir_projroot/cross-comp/accell/generated/output

bins_dir=bins
libs_dir=libs

mkdir -p $bins_dir
mkdir -p $libs_dir

if [ "$HOSTNAME" = WE40997 ]; then
  rsync -av -e ssh nico@lion:$arm_libs_dir/*.so.15git $libs_dir/.
  rsync -av -e ssh nico@lion:$arm_app_dir/*.so $libs_dir/.
  rsync -av -e ssh nico@lion:$arm_app_dir/*-app $bins_dir/.
else
  cp $arm_libs_dir/*.so.15git  $libs_dir/.
  cp $arm_app_dir/*.so $libs_dir/.
  cp $arm_app_dir/*-app $bins_dir/.
fi
