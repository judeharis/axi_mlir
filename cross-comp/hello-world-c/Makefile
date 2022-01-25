LLVM_X86_TOOLCHIAN=/working_dir/builds/llvm-project/build-x86
# Compilers
LLVMOPT=$(LLVM_X86_TOOLCHIAN)/bin/opt

# Paths and libraries
ARM_SROOT=/usr/arm-linux-gnueabihf
ARM_FLAGS=--target=arm-linux-gnueabihf -march=armv7-a -marm -mfloat-abi=hard
X86_FLAGS=--target=x86_64-pc-linux-gnu

CFLAGS=-I. $(ARM_FLAGS)
DEPS = 

APP=hello

# Commands

all: $(APP)
	file $(APP)

$(APP): $(APP).o
	$(CC) -o $@ $^ $(LDFLAGS)

# Generate ll files
%.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm -o $@ $^

# Generate assembly files
%.s: %.c
	$(CC) $(CFLAGS) -S -c -o $@ $< 

# Generate object binaries
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< 

.PHONY: run-arm
run-arm: $(APP)
	qemu-arm -L $(ARM_SROOT) ./$(APP)

.PHONY: targets
targets:
	$(CC) -print-targets
	$(CC) -print-target-triple

.PHONY: defaults
defaults:
	$(CC) -v -x c -E - </dev/null

.PHONY: clean
clean:
	rm -f *.o *.s *.ll $(APP) a.out
