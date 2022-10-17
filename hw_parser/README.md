# AXI4MLIR HW config parser
Goal of this tool is to parse handwritten hw config files for a given accelerator and produce some type of input file or list of arguement for the mlir-opt to produce the codegen correctly for the given accelerator.

Usage:
```
python hw_parser [name_of_config_file] 
```