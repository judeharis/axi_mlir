
    %51 = linalg.batch_matmul ins(%collapsed, %collapsed_56 : tensor<4x128x64xf32>, tensor<4x64x128xf32>) outs(%50 : tensor<4x128x128xf32>) -> tensor<4x128x128xf32>
    %67 = linalg.batch_matmul ins(%collapsed_58, %collapsed_59 : tensor<4x128x128xf32>, tensor<4x128x64xf32>) outs(%66 : tensor<4x128x64xf32>) -> tensor<4x128x64xf32>
    %72 = linalg.batch_matmul ins(%collapsed_61, %71 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %93 = linalg.batch_matmul ins(%87, %91 : tensor<2x128x128xf32>, tensor<2x128x512xf32>) outs(%92 : tensor<2x128x512xf32>) -> tensor<2x128x512xf32>
    %100 = linalg.batch_matmul ins(%95, %99 : tensor<2x128x512xf32>, tensor<2x512x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %118 = linalg.batch_matmul ins(%115, %117 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %122 = linalg.batch_matmul ins(%115, %121 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %127 = linalg.batch_matmul ins(%115, %126 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %132 = linalg.batch_matmul ins(%collapsed_65, %collapsed_66 : tensor<4x128x64xf32>, tensor<4x64x128xf32>) outs(%50 : tensor<4x128x128xf32>) -> tensor<4x128x128xf32>
    %140 = linalg.batch_matmul ins(%collapsed_68, %collapsed_69 : tensor<4x128x128xf32>, tensor<4x128x64xf32>) outs(%66 : tensor<4x128x64xf32>) -> tensor<4x128x64xf32>
    %144 = linalg.batch_matmul ins(%collapsed_71, %143 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %162 = linalg.batch_matmul ins(%159, %161 : tensor<2x128x128xf32>, tensor<2x128x512xf32>) outs(%92 : tensor<2x128x512xf32>) -> tensor<2x128x512xf32>
    %167 = linalg.batch_matmul ins(%164, %166 : tensor<2x128x512xf32>, tensor<2x512x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %185 = linalg.batch_matmul ins(%182, %184 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %206 = linalg.batch_matmul ins(%200, %204 : tensor<2x128x128xf32>, tensor<2x128x30522xf32>) outs(%205 : tensor<2x128x30522xf32>) -> tensor<2x128x30522xf32>


tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x64xf32>,  tensor<64x128xf32>   outs(%50 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x64xf32>    outs(%66 : tensor<128x64xf32>) -> tensor<128x64xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x512xf32>   outs(%92 : tensor<128x512xf32>) -> tensor<128x512xf32>
tensor<128x512xf32>, tensor<512x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x64xf32>,  tensor<64x128xf32>    outs(%50 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x64xf32>    outs(%66 : tensor<128x64xf32>) -> tensor<128x64xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x512xf32>   outs(%92 : tensor<128x512xf32>) -> tensor<128x512xf32>
tensor<128x512xf32>, tensor<512x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x128xf32>   outs(%32 : tensor<128x128xf32>) -> tensor<128x128xf32>
tensor<128x128xf32>, tensor<128x30522xf32> outs(%205 : tensor<128x30522xf32>) -> tensor<128x30522xf32>