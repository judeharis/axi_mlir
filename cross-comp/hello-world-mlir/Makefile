LLVM_X86_TOOLCHIAN=/working_dir/builds/llvm-project/build-cross

# Compilers
CC=$(LLVM_X86_TOOLCHIAN)/bin/clang
LLVMOPT=$(LLVM_X86_TOOLCHIAN)/bin/opt
MLIROPT=$(LLVM_X86_TOOLCHIAN)/bin/mlir-opt
MLIRTRAN=$(LLVM_X86_TOOLCHIAN)/bin/mlir-translate
# LD=arm-linux-gnueabihf-gcc-7

# Paths and flags
MLIRLIB=/working_dir/builds/llvm-project/build-runner-arm/lib
MLIRRUNNERLIBS=$(MLIRLIB)/libmlir_runner_utils.so
RUNNER_FLAGS=-L$(MLIRLIB) -lmlir_runner_utils
ARM_SROOT=/usr/arm-linux-gnueabihf
# ARM_FLAGS=--target=arm-linux-gnueabihf --sysroot=/usr/arm-linux-gnueabihf -B /usr/lib/arm-linux-gnueabihf -L /usr/lib/arm-linux-gnueabihf -I /usr/arm-linux-gnueabihf/include
ARM_FLAGS=--target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard
# X86_FLAGS=--target=x86_64-pc-linux-gnu

LDFLAGS= -Wl,-rpath=$(MLIRLIB) $(RUNNER_FLAGS)
CFLAGS=$(ARM_FLAGS)
DEPS = 

APP=app

# Commands

# all: simple main
# 	file simple
# 	file main

all: app
	file app

# Order of LDFLAGS matter
$(APP): $(APP).o
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
run-arm: app
	qemu-arm -L $(ARM_SROOT) ./app

.PHONY: targets
targets:
	$(CC) -print-targets
	$(CC) -print-target-triple

.PHONY: defaults
defaults:
	$(CC) -v -x c -E - </dev/null

.PHONY: clean
clean:
	rm -f *.o *.s *.ll a.out *-llvm.mlir $(APP)
