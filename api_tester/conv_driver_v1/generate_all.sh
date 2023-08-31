# MArray=(
#   "-DIHW=9 -DIC=8 -DFHW=5 -DOC=3 -DST=1"
#   "-DIHW=9 -DIC=8 -DFHW=5 -DOC=3 -DST=1"
# )

# CC=/home/jude/Workspace/PYNQCC/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++ 
# ARM_FLAGS="-marm -mfloat-abi=hard -march=armv7-a -mfpu=neon -funsafe-math-optimizations -ftree-vectorize -fPIC"

# LLVM=../../llvm-project/mlir
# set -x
# for M in ${MArray[*]}; do
# $CC -c -o pynq_out/pynq_api_v1.o ../../llvm-project/mlir/lib/ExecutionEngine/axi/api_v1.cpp -I../../llvm-project/mlir/include -DREAL -DACC_NEON $ARM_FLAGS
# $CC -shared -o pynq_out/libpynq_api_v1.so pynq_out/pynq_api_v1.o
# $CC -Lpynq_out/ -Wall -o pynq_out/conv_v3_t1 ./conv_v3_t1.cc -lpynq_api_v1 -fPIC -DREAL -DACC_NEON -I../../llvm-project/mlir/include $ARM_FLAGS $M
# done
# set +x

./generate_all.py