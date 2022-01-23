This sample project presents a make file to compile C code to arm devices.

It expects clang and llvm built for cross-compilation to ARM targets.

```bash
cd <proj_root>
<proj_root>/build_tools/./build_llvm_dev_cross.sh llvm-project/ builds/llvm-project/build/ builds/llvm-project/install
```


To compile, run `make`

To check if compiler supports ARM target triple, run `make targets`

To check what default flags and paths are sent to compiler, run `make defaults`

If qemu is installed, `make run-arm` will execute the binary in qemu.