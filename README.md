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