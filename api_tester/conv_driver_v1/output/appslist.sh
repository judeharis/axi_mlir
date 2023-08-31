declare -a AppArray=(
    driver-conv2d-B1_IHW230_IC3_FHW7_OC64_ST2-MANUAL_ACC-CONV_v3-Fs-app
    driver-conv2d-B1_IHW230_IC3_FHW7_OC64_ST2-MLIR_CPU-NONE-NONE-app
    driver-conv2d-B1_IHW230_IC3_FHW7_OC64_ST2-MLIR_ACC-CONV_v3-Fs-app
)
length=${#AppArray[@]}
for ((j = 0; j < length; j++)); do
  ./output/${AppArray[$j]}
done
