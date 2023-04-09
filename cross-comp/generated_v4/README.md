# Usage

## To regenerate the source MLIR file

To create all the necceary files to solve problems defined in generate_all.py call:
./generate.sh


This will call the following:

```bash
./generate_all.py --template srcs/template_mlir_matmuls.mlir > srcs/mlir_matmuls.mlir
./generate_all.py --template srcs/template_mlir_matmuls.h > srcs/mlir_matmuls.h.inc
./generate_all.py --template srcs/template_cmd.h > scripts/compile_mlir_matmul-all.sh
```

After you can call:
./compile [arm|sysc] [0|dbg] [0|test]