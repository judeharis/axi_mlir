CC=/working_dir/builds/llvm-project/build-cross/bin/clang
MLIR=/working_dir/builds/llvm-project/build-cross/bin/clang
# ARM_SROOT=/usr/arm-linux-gnueabihf
# ARM_FLAGS=--target=arm-linux-gnueabihf --sysroot=$(ARM_SROOT) --gcc-toolchain=/usr/lib/gcc-cross/arm-linux-gnueabihf/7.5.0  -I$(ARM_SROOT)/include/ -L$(ARM_SROOT)/lib -L/lib/gcc/x86_64-linux-gnu/7/
ARM_FLAGS=--target=arm-linux-gnueabihf --static
X86_FLAGS=--target=x86_64-pc-linux-gnu

CFLAGS=-I. $(ARM_FLAGS)
DEPS = 

# Commands

all: hello
	file hello

hello: hello.o
	$(CC) $(CFLAGS) -o $@ $^

# Generate ll files
%.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm -o $@ $^

# Generate assembly files
%.s: %.c
	$(CC) $(CFLAGS) -S -c -o $@ $< 

# Generate object binaries
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< 

# Rule to make directories
# .PHONY: directories
# directories: ${OBJDIR}
# ${OBJDIR}:
# 	${MKDIR_P} ${OBJDIR}

.PHONY: run-arm
run-arm: hello
	qemu-arm ./hello

.PHONY: targets
targets:
	$(CC) -print-targets
	$(CC) -print-target-triple

.PHONY: defaults
defaults:
	$(CC) -v -x c -E - </dev/null

.PHONY: clean
clean:
	rm -f *.o *.s *.ll hello a.out
