
# Using the precompiled wheels


```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
source ~/.bashrc


conda create -y -n torch-mlir python=3.11
conda activate torch-mlir
pip install --pre torch-mlir -f https://llvm.github.io/torch-mlir/package-index/ --extra-index-url https://download.pytorch.org/whl/nightly/cpu
pip install transformers
```


# Dockerfile

```
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
```