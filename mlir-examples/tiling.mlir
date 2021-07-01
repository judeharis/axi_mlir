// This example can be completely translated to llvm IR
// code with:
//
// mlir-opt tiling.mlir --print-ir-before-all -linalg-tile="linalg-tile-sizes=2,2,2" --convert-linalg-to-loops --lower-affine --convert-scf-to-std -convert-std-to-llvm

// There are two options to perform tiling in MLIR

// Tiling in the affine dialect:
//
// mlir-opt tiling.mlir --print-ir-before-all --canonicalize --linalg-generalize-named-ops --convert-linalg-to-affine-loops -affine-loop-tile="tile-size=2"

// Tiling in the linalg dialect
//
// mlir-opt tiling.mlir --print-ir-before-all -linalg-tile="linalg-tile-sizes=2,2,2"
func @generalize_matmul_buffer(%A : memref<16x8xf32>, %B: memref<8x32xf32>, %C: memref<16x32xf32>) {
  linalg.matmul ins(%A, %B: memref<16x8xf32>, memref<8x32xf32>)
    outs(%C: memref<16x32xf32>)
    return
}
