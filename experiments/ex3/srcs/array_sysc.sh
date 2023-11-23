declare -a TagArray=(
  "B1_IHW230_IC3_FHW7_OC64_ST2-MLIR-ACC-v3-Fs" 
  "B1_IHW58_IC64_FHW3_OC64_ST1-MLIR-ACC-v3-Fs" 
  "B1_IHW56_IC64_FHW1_OC128_ST2-MLIR-ACC-v3-Fs" 
  "B1_IHW58_IC64_FHW3_OC128_ST2-MLIR-ACC-v3-Fs" 
  "B1_IHW30_IC128_FHW3_OC128_ST1-MLIR-ACC-v3-Fs" 
  "B1_IHW28_IC128_FHW1_OC256_ST2-MLIR-ACC-v3-Fs" 
  "B1_IHW30_IC128_FHW3_OC256_ST2-MLIR-ACC-v3-Fs" 
  "B1_IHW16_IC256_FHW3_OC256_ST1-MLIR-ACC-v3-Fs" 
  "B1_IHW14_IC256_FHW1_OC512_ST2-MLIR-ACC-v3-Fs" 
  "B1_IHW16_IC256_FHW3_OC512_ST2-MLIR-ACC-v3-Fs" 
  "B1_IHW9_IC512_FHW3_OC512_ST1-MLIR-ACC-v3-Fs" 
)
declare -a BArray=(
  "1" 
  "1" 
  "1" 
  "1" 
  "1" 
  "1" 
  "1" 
  "1" 
  "1" 
  "1" 
  "1" 
)
declare -a IHWArray=(
  "230" 
  "58" 
  "56" 
  "58" 
  "30" 
  "28" 
  "30" 
  "16" 
  "14" 
  "16" 
  "9" 
)
declare -a ICArray=(
  "3" 
  "64" 
  "64" 
  "64" 
  "128" 
  "128" 
  "128" 
  "256" 
  "256" 
  "256" 
  "512" 
)
declare -a FHWArray=(
  "7" 
  "3" 
  "1" 
  "3" 
  "3" 
  "1" 
  "3" 
  "3" 
  "1" 
  "3" 
  "3" 
)
declare -a OCArray=(
  "64" 
  "64" 
  "128" 
  "128" 
  "128" 
  "256" 
  "256" 
  "256" 
  "512" 
  "512" 
  "512" 
)
declare -a STArray=(
  "2" 
  "1" 
  "2" 
  "2" 
  "1" 
  "2" 
  "2" 
  "1" 
  "2" 
  "2" 
  "1" 
)
declare -a LangArray=(
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
  "MLIR" 
)
declare -a TargetArray=(
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
  "ACC" 
)
declare -a AccelNameArray=(
  "v3" 
  "v3" 
  "v3" 
  "v3" 
  "v3" 
  "v3" 
  "v3" 
  "v3" 
  "v3" 
  "v3" 
  "v3" 
)
declare -a DataflowArray=(
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
  "Fs" 
)
declare -a IWHxIHWArray=(
)
declare -a FHWxFHWArray=(
)
declare -a OHWxOHWArray=(
  "112" 
  "56" 
  "28" 
  "28" 
  "28" 
  "14" 
  "14" 
  "14" 
  "7" 
  "7" 
  "7" 
)
declare -a IHWxIHWxICArray=(
)
declare -a FHWxFHWxICArray=(
)
declare -a FHWxFHWxOCArray=(
)
declare -a OHWxOHWxOCArray=(
)
declare -a MLIRCallArray=(
  "conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW58_IC64_FHW3_OC64_ST1_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW56_IC64_FHW1_OC128_ST2_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW58_IC64_FHW3_OC128_ST2_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW30_IC128_FHW3_OC128_ST1_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW28_IC128_FHW1_OC256_ST2_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW30_IC128_FHW3_OC256_ST2_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW16_IC256_FHW3_OC256_ST1_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW14_IC256_FHW1_OC512_ST2_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW16_IC256_FHW3_OC512_ST2_MLIR_ACC_v3_call" 
  "conv2d_B1_IHW9_IC512_FHW3_OC512_ST1_MLIR_ACC_v3_call" 
)
