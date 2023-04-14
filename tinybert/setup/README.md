RUN git init /torch_mlir_src && \
    cd /torch_mlir_src && \
    git remote add origin ${TORCHMLIR_URL} && \
    git fetch --depth=1 origin ${TORCHMLIR_COMMIT} && \
    git reset --hard ${TORCHMLIR_COMMIT} && \
    git submodule init && \
    git submodule update --depth=1 --recursive

# TODO: Only compile and install the necessary targets from LLVM/TORCH_MLIR
#       torch-mlir-opt TorchMLIRPythonModules
RUN mkdir -p /builds/torch-mlir /installs/torch-mlir && \
    cmake -GNinja \
        -B/builds/torch-mlir \
        -H/torch_mlir_src/externals/llvm-project/llvm \
        -DCMAKE_INSTALL_PREFIX=/installs/torch-mlir \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DLLVM_ENABLE_PROJECTS=mlir \
        -DLLVM_EXTERNAL_PROJECTS="torch-mlir;torch-mlir-dialects" \
        -DLLVM_EXTERNAL_TORCH_MLIR_SOURCE_DIR=/torch_mlir_src \
        -DLLVM_EXTERNAL_TORCH_MLIR_DIALECTS_SOURCE_DIR=/torch_mlir_src/externals/llvm-external-projects/torch-mlir-dialects \
        -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
        -DLLVM_ENABLE_ASSERTIONS=ON \
        -DLLVM_TARGETS_TO_BUILD=host && \
    cd /builds/torch-mlir && \
    ninja tools/torch-mlir/all install