# axi4mlir

* Library for AXI based data transfers to be used with AXI IR


# MLIR Dependencies:

Download the most recent verision of cmake installer and ninja binary and add to path:

```
https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu#comment1262462_829311
https://cmake.org/download/
https://github.com/ninja-build/ninja/releases
```

Install clang-10 clang++-10 and lld-10.

Execute the folowing commands where you want to have a copy of the LLVM project:

## Instructions

To setup the project, use:

```shell
$ git clone https://github.com/judeharis/axi_mlir.git axi4mlir
$ cd axi4mlir
$ git submodule init
$ git submodule update
```

Then apply the llvm-project patch, enabling the runtime of axi4mlir:

```shell
cd llvm-project 
git branch -c axi4mlir
git apply ../llvm-project-patches/axi4mlir-mock-v1-rev00.patch
```

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
export PATH=$PATH:$(pwd)/llvm-project/build/bin
```

### Generating new llvm-project patches

```shell
# Make changes to llvm-project in a separate branch
git diff main > ../llvm-project-patches/axi4mlir-<patch_name>-rev<rev_number>.patch
```