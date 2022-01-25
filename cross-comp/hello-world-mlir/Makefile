LLVM_X86_TOOLCHIAN=/working_dir/builds/llvm-project/build-x86

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

# Target System Root for libraries
ARM_SROOT=/usr/arm-linux-gnueabihf
AARCH64_SROOT=/usr/aarch64-linux-gnu

# Target triple
ARM_TARGET_TRIPLE=arm-linux-gnueabihf
# X86_TARGET_TRIPLE=x86_64-linux-gnu
# AARCH64_TARGET_TRIPLE=aarch64-linux-gnu
TARGET_TRIPLE=$(ARM_TARGET_TRIPLE)

ARM_FLAGS=--target=$(ARM_TARGET_TRIPLE) -march=armv7-a -marm -mfloat-abi=hard
# AARCH64_FLAGS=--target=$(AARCH64_TARGET_TRIPLE) -march=armv8-a -marm
# X86_FLAGS=--target=$(X86_TARGET_TRIPLE)

LDFLAGS=--target=$(TARGET_TRIPLE) -Wl,-rpath=$(MLIRLIB) $(RUNNER_FLAGS)
CFLAGS=$(ARM_FLAGS)
DEPS = 

# APP=simple
APP=app

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

# qemu run targets
.PHONY: run-arm
run-arm: app
	qemu-arm -L $(ARM_SROOT) ./app

.PHONY: run-aarch64
run-aarch64: app
	qemu-aarch64 -L $(AARCH64_SROOT) ./app

# debug info targets
.PHONY: targets
targets:
	$(CC) -print-targets
	$(CC) -print-target-triple

.PHONY: defaults
defaults:
	$(CC) -v -x c -E - </dev/null

# clean targets
.PHONY: clean
clean:
	rm -f *.o *.s *.ll a.out *-llvm.mlir $(APP)
