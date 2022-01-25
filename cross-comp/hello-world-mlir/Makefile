CC=/working_dir/builds/llvm-project/build-cross/bin/clang
# CC=arm-linux-gnueabihf-gcc-7
LD=arm-linux-gnueabihf-gcc-7
LLVMOPT=/working_dir/builds/llvm-project/build-cross/bin/opt
MLIROPT=/working_dir/builds/llvm-project/build-cross/bin/mlir-opt
MLIRTRAN=/working_dir/builds/llvm-project/build-cross/bin/mlir-translate
MLIRLIB=/working_dir/builds/llvm-project/build-runner-arm/lib

# builds/llvm-project/build-x86/bin/clang --target=arm --sysroot=/usr/arm-linux-gnueabihf -B /usr/lib/arm-linux-gnueabihf -L /usr/lib/arm-linux-gnueabihf -I /usr/arm-linux-gnueabihf/include -v -x c -E < /dev/null

MLIRRUNNERLIBS=$(MLIRLIB)/libmlir_runner_utils.so
RUNNER_FLAGS=-L$(MLIRLIB) -lmlir_runner_utils
ARM_SROOT=/usr/arm-linux-gnueabihf
# ARM_FLAGS=--target=arm-linux-gnueabihf --sysroot=$(ARM_SROOT) --gcc-toolchain=/usr/lib/gcc-cross/arm-linux-gnueabihf/7.5.0  -I$(ARM_SROOT)/include/ -L$(ARM_SROOT)/lib -L/lib/gcc/x86_64-linux-gnu/7/
# ARM_FLAGS=--target=arm-linux-gnueabihf --static
# ARM_FLAGS=--target=arm-linux-gnueabihf --sysroot=/usr/arm-linux-gnueabihf -B /usr/lib/arm-linux-gnueabihf -L /usr/lib/arm-linux-gnueabihf -I /usr/arm-linux-gnueabihf/include
ARM_FLAGS=--target=arm-linux-gnueabihf
# X86_FLAGS=--target=x86_64-pc-linux-gnu

# LDFLAGS=$(ARM_FLAGS) -static $(MLIRRUNNERLIBS)
LDFLAGS= -Wl,-rpath=$(MLIRLIB) $(RUNNER_FLAGS)
CFLAGS=$(ARM_FLAGS)
DEPS = 

# Commands

# all: simple main
# 	file simple
# 	file main

all: main
	file main

simple: simple.o
	$(CC) $(CFLAGS) -o $@ $^

main: main.o
	$(CC) -o $@ $^ $(LDFLAGS) 

# Generate xxxx-llvm.mlir files in llvm dialect
%-llvm.mlir: %.mlir
	$(MLIROPT) -convert-linalg-to-loops -convert-scf-to-std -convert-linalg-to-llvm -lower-affine -convert-scf-to-std --convert-memref-to-llvm -convert-std-to-llvm -reconcile-unrealized-casts -o $@ $< 

# Generate ll files
%.ll: %-llvm.mlir
	$(MLIRTRAN) -mlir-to-llvmir -o $@ $< 

# Generate assembly files
%.s: %.ll
	$(CC) $(CFLAGS) -S -c -o $@ $< 

# Generate object binaries
%.o: %.ll
	$(CC) $(CFLAGS) -c -o $@ $< 

# Rule to make directories
# .PHONY: directories
# directories: ${OBJDIR}
# ${OBJDIR}:
# 	${MKDIR_P} ${OBJDIR}

.PHONY: run-arm
run-arm: simple
	qemu-arm ./simple

.PHONY: targets
targets:
	$(CC) -print-targets
	$(CC) -print-target-triple

.PHONY: defaults
defaults:
	$(CC) -v -x c -E - </dev/null

.PHONY: clean
clean:
	rm -f *.o *.s *.ll simple main a.out *-llvm.mlir
