username=xxx
hostname=vvv


axi4mlir_projroot=/home/$username/Development/axi4mlir/
arm_libs_dir=$axi4mlir_projroot/builds/llvm-project/build-runner-arm/lib
#arm_app_dir=$axi4mlir_projroot/cross-comp/hello-world-mlir
arm_app_dir=$axi4mlir_projroot/cross-comp/accell

target_dir=output

mkdir -p $target_dir

rsync -av -e ssh $username@$hostname:$arm_libs_dir/*.so.15git $target_dir/.
sleep 1
rsync -av -e ssh $username@$hostname:$arm_app_dir/app $target_dir/app