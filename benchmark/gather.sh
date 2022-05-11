
axi4mlir_projroot=/mnt/UDrive/UWorkspace/AXI4MLIR/axi4mlir/
arm_libs_dir=$axi4mlir_projroot/builds/llvm-project/build-runner-arm/lib
arm_app_dir=$axi4mlir_projroot/cross-comp/accell/generated/output

bins_dir=bins
libs_dir=libs

mkdir -p $bins_dir
mkdir -p $libs_dir


cp $arm_libs_dir/*.so.15git  $libs_dir/.
cp $arm_app_dir/*.so $libs_dir/.
cp $arm_app_dir/matmuldriver-64-app $bins_dir/matmuldriver-app
