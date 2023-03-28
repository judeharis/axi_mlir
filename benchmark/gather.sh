#!/bin/bash

if [ "$HOSTNAME" = WE40997 ]; then
  axi4mlir_projroot=/home/nico/Development/axi4mlir/
elif [ "$HOSTNAME" = jude ]; then
  axi4mlir_projroot=/home/jude/Workspace/AXI4MLIR/axi4mlir/
elif [ "$HOSTNAME" = AORUS-W ]; then
  axi4mlir_projroot=/home/agostini/Development/axi_mlir/
elif [ "$HOSTNAME" = lion ]; then
  axi4mlir_projroot=/home/nico/Development/axi4mlir/
else
  echo "Hostname not recognized. Exiting..."
  exit 0
fi

arm_libs_dir=$axi4mlir_projroot/builds/llvm-project/build-runner-arm/lib
arm_app_dir=$axi4mlir_projroot/cross-comp/generated/output

bins_dir=bins
libs_dir=libs

mkdir -p $bins_dir
mkdir -p $libs_dir

if [ "$HOSTNAME" = WE40997 ]; then
  rsync -av -e ssh nico@lion:$arm_libs_dir/*.so.15git $libs_dir/.
  rsync -av -e ssh nico@lion:$arm_app_dir/*.so $libs_dir/.
  rsync -av -e ssh nico@lion:$arm_app_dir/*-app $bins_dir/.
elif [ "$HOSTNAME" = jude ]; then
  cp $arm_libs_dir/*.so.15git  $libs_dir/.
  cp $arm_app_dir/*.so $libs_dir/.
  cp $arm_app_dir/*-app $bins_dir/.
elif [ "$HOSTNAME" = AORUS-W ]; then
  cp $arm_libs_dir/*.so.15git  $libs_dir/.
  cp $arm_app_dir/*.so $libs_dir/.
  cp $arm_app_dir/*-app $bins_dir/.
elif [ "$HOSTNAME" = lion ]; then
  cp $arm_libs_dir/*.so.15git  $libs_dir/.
  cp $arm_app_dir/*.so $libs_dir/.
  cp $arm_app_dir/*-app $bins_dir/.
fi
