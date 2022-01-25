# axi4mlir

* Library for AXI based data transfers to be used with AXI IR


# MLIR Dependencies:

Download the most recent version of cmake installer and ninja binary and add to
path:

```
https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu#comment1262462_829311
https://cmake.org/download/
https://github.com/ninja-build/ninja/releases
```

Install clang-10 clang++-10 and lld-10.

Download and install latest version of SystemC and export its path:

```
# Follow instructions at the end of the page to use this path
export SYSTEMC_HOME=/opt/systemc/systemc-2.3.3
```

Execute the following commands where you want to have a copy of the LLVM project:

## Instructions

To setup the project, use:

```shell
$ git clone https://github.com/judeharis/axi_mlir.git axi4mlir
$ cd axi4mlir
$ git submodule init
$ git submodule update
```

This should clone the `axi4mlir` branch of `llvm-project`.

A helper script is provided to build the llvm-project

```shell
$ mkdir -p builds/llvm-project/build builds/llvm-project/install

$ ./build_tools/build_llvm_dev.sh \
    llvm-project \
    builds/llvm-project/build \
    builds/llvm-project/install
```

Add mlir binaries to path:

```
export PATH=$PATH:$(pwd)/builds/llvm-project/build/bin
```

## Standalone AXI API execution

It is possible to compile the AXI API as a library to use in another project.

```shell
# In the LLVM_BUILD folder run
ninja mlir_axi_runner_utils 
```
This will generate 2 files:

* `<build_folder>/lib/libaxi_api_v1.so` - to link with any C project
* `<build_folder>/lib/libmlir_axi_runner_utils.so` - to be used by mlir-cpu-runner

## MLIR Example

An example of using the API from a MLIR file can be found
[here](https://github.com/agostini01/llvm-project/blob/axi4mlir/mlir/test/mlir-cpu-runner/axi_v1.mlir).


## Installing SystemC

```shell
# Prepare important folders
mkdir -p ~/Downloads/systemc/
sudo mkdir -p /opt/systemc/systemc-2.3.3

# Download
pushd ~/Downloads/systemc
wget https://accellera.org/images/downloads/standards/systemc/systemc-2.3.3.tar.gz
tar -xvf systemc-2.3.3.tar.gz 

# Compile and install
mkdir ~/Downloads/systemc/systemc-2.3.3/build
pushd ~/Downloads/systemc/systemc-2.3.3/build
../configure --prefix=/opt/systemc/systemc-2.3.3/
make -j10
sudo make install

# Set the relevant environment variables
export SYSTEMC_HOME=/opt/systemc/systemc-2.3.3
popd
popd
```

## Running SystemC

After compiling llvm and installing SystemC, a systemc library can be compiled
with:

```shell
cd $PROJ_ROOT/builds/llvm-project/build
ninja mlir_syscaxi_runner_utils
```

A 4 by 4 matmul example can be executed with mlir jitter, triggering a systemC
simulation with:
```
$PROJ_ROOT/builds/llvm-project/build/bin/mlir-opt \
        -convert-linalg-to-loops -convert-scf-to-std   -convert-vector-to-llvm \
        -convert-memref-to-llvm -convert-std-to-llvm -reconcile-unrealized-casts \
        $PROJ_ROOT/llvm-project/mlir/test/axi4mlir-runner/axi_v1_data_copy.mlir | \
    $PROJ_ROOT/builds/llvm-project/build/bin/mlir-cpu-runner \
        -O0 -e main -entry-point-result=void \
        -shared-libs=$PROJ_ROOT/builds/llvm-project/build/lib/libmlir_syscaxi_runner_utils.so \
        -shared-libs=$PROJ_ROOT/builds/llvm-project/build/lib/libmlir_runner_utils.so 
```

The same mlir code is automatically executed with `ninja check-mlir`, but the
llvm tests only check for the existence of the dma mock library
(`libmlir_mockaxi_runner_utils.so`) without systemc simulation:
```shell
$PROJ_ROOT/builds/llvm-project/build/bin/mlir-opt \
        -convert-linalg-to-loops -convert-scf-to-std   -convert-vector-to-llvm \
        -convert-memref-to-llvm -convert-std-to-llvm -reconcile-unrealized-casts \
        $PROJ_ROOT/llvm-project/mlir/test/axi4mlir-runner/axi_v1_data_copy.mlir | \
    $PROJ_ROOT/builds/llvm-project/build/bin/mlir-cpu-runner \
        -O0 -e main -entry-point-result=void \
        -shared-libs=$PROJ_ROOT/builds/llvm-project/build/lib/libmlir_mockaxi_runner_utils.so \
        -shared-libs=$PROJ_ROOT/builds/llvm-project/build/lib/libmlir_runner_utils.so 
```


A `C(16x32) = A(16x8) x B(8x32)` accelerator v1 example can be executed with
the mlir jitter, triggering a systemC simulation with:
```
$PROJ_ROOT/builds/llvm-project/build/bin/mlir-opt \
        -convert-linalg-to-loops -convert-scf-to-std   -convert-vector-to-llvm \
        -convert-memref-to-llvm -convert-std-to-llvm -reconcile-unrealized-casts \
        $PROJ_ROOT/llvm-project/mlir/test/axi4mlir-runner/matmul_accelerator_v1_naive.mlir | \
    $PROJ_ROOT/builds/llvm-project/build/bin/mlir-cpu-runner \
        -O0 -e main -entry-point-result=void \
        -shared-libs=$PROJ_ROOT/builds/llvm-project/build/lib/libmlir_syscaxi_runner_utils.so \
        -shared-libs=$PROJ_ROOT/builds/llvm-project/build/lib/libmlir_runner_utils.so 
```
# Using docker

To create a standalone image with all build dependencies installed follow execute:

```
./build-docker.sh
```

To enter the development container

```
./start-docker.sh
```


## Building and testing MLIR inputs in armv7-a devices

Steps:

1. Enter development container
    - With qemu-user, crossbuild-essential-armhf, libz-dev installed
2. Compile bootstrap mlir-tblgen binaries 
    - required when cross compiling for arm
3. Compile clang, llvm, mlir for x86 with the required targets
4. Cross-compile mlir-runner libraries for ARM 
    - this requires arm libs and llvm-project/cmake targeting cross-compilation
    - needs mlir-tblgen from step 2
5. Compile and link desired application for arm, run with qemu
    -  Using compiler from step 3, libraries from step 4, and pointing qemu to look for the right libraries

```bash
# 1. Enter development container
./start-docker.sh # Further steps are executed inside docker container with automatic pwd mounted

# 2. Compile bootstrap mlir-tblgen binaries
./build_tools/build_bootstrap_tblgen.sh llvm-project builds/llvm-project/build builds/llvm-project/install

# 3. Compile clang, llvm, mlir for x86 with the required targets
# This will take a while (20min using 16c/32t)
./build_tools/build_llvm_dev_x86.sh llvm-project builds/llvm-project/build builds/llvm-project/install

# 4. Cross-compile mlir-runner libraries for ARM 
./build_tools/build_runner_arm.sh llvm-project builds/llvm-project/build builds/llvm-project/install

# 5. Compile and link desired application for arm, run with qemu
cd cross-comp/hello-world-mlir
make
make run-arm

# Or for individual steps on AOT compiling app.mlir into an arm binary
cp llvm-project/mlir/test/Integration/Dialect/Linalg/CPU/test-conv-1d-nwc-wcf-call.mlir app.mlir
/working_dir/builds/llvm-project/build-x86/bin/mlir-opt -convert-linalg-to-loops -convert-scf-to-std -convert-linalg-to-llvm -lower-affine -convert-scf-to-std --convert-memref-to-llvm -convert-std-to-llvm -reconcile-unrealized-casts -o app-llvm.mlir app.mlir
/working_dir/builds/llvm-project/build-x86/bin/mlir-translate -mlir-to-llvmir -o app.ll app-llvm.mlir
/working_dir/builds/llvm-project/build-x86/bin/clang --target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard -c -o app.o app.ll
/working_dir/builds/llvm-project/build-x86/bin/clang -o app app.o --target=arm-linux-gnueabihf -Wl,-rpath=/working_dir/builds/llvm-project/build-runner-arm/lib -L/working_dir/builds/llvm-project/build-runner-arm/lib -lmlir_runner_utils
# Running with qemu
qemu-arm -L /usr/arm-linux-gnueabihf ./app
```