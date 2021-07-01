# axi_mlir

* Library for AXI based data transfers to be used with AXI IR


# MLIR Installation:

Download the most recent verision of cmake installer and ninja binary and add to path:

```
https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu#comment1262462_829311
https://cmake.org/download/
https://github.com/ninja-build/ninja/releases
```

Install clang-10 clang++-10 and lld-10.

Execute the folowing commands where you want to have a copy of the LLVM project:

```
git clone https://github.com/llvm/llvm-project.git --depth=1
cd llvm-project
mkdir build
cd build

cmake -G Ninja ../llvm \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_C_COMPILER=clang-10 \
    -DCMAKE_CXX_COMPILER=clang++-10 \
    -DLLVM_INSTALL_UTILS=ON

```

Compile:

```
ninja mlir-opt mlir-translate mlir-cpu-runner check-mlir FileCheck
```

Add mlir binaries to path:

```
export PATH=$PATH:$(pwd)/bin
```