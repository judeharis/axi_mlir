#map = affine_map<(d0, d1) -> (0, d1)>
#map1 = affine_map<(d0, d1) -> (d0, d1)>
#map2 = affine_map<(d0, d1, d2, d3) -> (d0, 0, 0, d3)>
#map3 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>
#map4 = affine_map<(d0, d1, d2, d3) -> ()>
#map5 = affine_map<(d0, d1, d2) -> (d0, d1)>
#map6 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
#map7 = affine_map<(d0, d1, d2) -> (0, d1, d2)>
#map8 = affine_map<(d0, d1, d2) -> (d0, d1, 0)>
#map9 = affine_map<(d0, d1, d2) -> (d2)>
#map10 = affine_map<(d0, d1) -> (d1, d0)>
#map11 = affine_map<(d0, d1, d2) -> (d1, d2)>
#map12 = affine_map<(d0, d1, d2, d3) -> (d0, d2, d1, d3)>
#map13 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d3, d2)>
#map14 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, 0)>
module attributes {torch.debug_module_name = "BertTinyWrapper"} {
  ml_program.global private mutable @global_seed(dense<0> : tensor<i64>) : tensor<i64>
  func.func @forward(%arg0: tensor<2x128xi64>) -> tensor<2x128x30522xf32> {
    %0 = tensor.empty() : tensor<2x128xf32>
    %extracted_slice = tensor.extract_slice %cst_43[0, 0] [1, 128] [1, 1] : tensor<1x512xi64> to tensor<1x128xi64>
    %1 = tensor.empty() : tensor<2x128xi64>
    %2 = linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice : tensor<1x128xi64>) outs(%1 : tensor<2x128xi64>) {
    ^bb0(%in: i64, %out: i64):
      linalg.yield %in : i64
    } -> tensor<2x128xi64>
    %expanded = tensor.expand_shape %0 [[0], [1, 2, 3]] : tensor<2x128xf32> into tensor<2x1x1x128xf32>
    %3 = linalg.fill ins(%cst_45 : f32) outs(%expanded : tensor<2x1x1x128xf32>) -> tensor<2x1x1x128xf32>
    %4 = tensor.empty() : tensor<2x1x1x128xf32>
    %5 = linalg.generic {indexing_maps = [#map2, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%3 : tensor<2x1x1x128xf32>) outs(%4 : tensor<2x1x1x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.subf %cst_45, %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x1x1x128xf32>
    %6 = linalg.generic {indexing_maps = [#map2, #map4, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%5, %cst_42 : tensor<2x1x1x128xf32>, tensor<f64>) outs(%4 : tensor<2x1x1x128xf32>) {
    ^bb0(%in: f32, %in_72: f64, %out: f32):
      %208 = arith.truncf %in_72 : f64 to f32
      %209 = arith.mulf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x1x1x128xf32>
    %extracted_slice_52 = tensor.extract_slice %cst_41[0, 0] [1, 128] [1, 1] : tensor<1x512xi64> to tensor<1x128xi64>
    %7 = tensor.empty() : tensor<2x128x128xf32>
    %8 = linalg.generic {indexing_maps = [#map5, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%arg0 : tensor<2x128xi64>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: i64, %out: f32):
      %208 = arith.index_cast %in : i64 to index
      %209 = linalg.index 2 : index
      %210 = arith.cmpi slt, %208, %c30522 : index
      cf.assert %210, "index must be smaller than dim size"
      %211 = arith.cmpi sge, %in, %c0_i64 : i64
      cf.assert %211, "index must be larger or equal to 0"
      %extracted = tensor.extract %cst_44[%208, %209] : tensor<30522x128xf32>
      linalg.yield %extracted : f32
    } -> tensor<2x128x128xf32>
    %9 = linalg.generic {indexing_maps = [#map5, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%2 : tensor<2x128xi64>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: i64, %out: f32):
      %208 = arith.index_cast %in : i64 to index
      %209 = linalg.index 2 : index
      %210 = arith.cmpi slt, %208, %c2 : index
      cf.assert %210, "index must be smaller than dim size"
      %211 = arith.cmpi sge, %in, %c0_i64 : i64
      cf.assert %211, "index must be larger or equal to 0"
      %extracted = tensor.extract %cst_40[%208, %209] : tensor<2x128xf32>
      linalg.yield %extracted : f32
    } -> tensor<2x128x128xf32>
    %10 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%8, %9 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %11 = tensor.empty() : tensor<1x128x128xf32>
    %12 = linalg.generic {indexing_maps = [#map5, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%extracted_slice_52 : tensor<1x128xi64>) outs(%11 : tensor<1x128x128xf32>) {
    ^bb0(%in: i64, %out: f32):
      %208 = arith.index_cast %in : i64 to index
      %209 = linalg.index 2 : index
      %210 = arith.cmpi slt, %208, %c512 : index
      cf.assert %210, "index must be smaller than dim size"
      %211 = arith.cmpi sge, %in, %c0_i64 : i64
      cf.assert %211, "index must be larger or equal to 0"
      %extracted = tensor.extract %cst_39[%208, %209] : tensor<512x128xf32>
      linalg.yield %extracted : f32
    } -> tensor<1x128x128xf32>
    %13 = linalg.generic {indexing_maps = [#map6, #map7, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%10, %12 : tensor<2x128x128xf32>, tensor<1x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %14 = tensor.empty() : tensor<2x128x1xf32>
    %15 = linalg.fill ins(%cst_46 : f32) outs(%14 : tensor<2x128x1xf32>) -> tensor<2x128x1xf32>
    %16 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%13 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %17 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%16 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %18 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%17 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %19 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%13, %18 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %20 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%19, %19 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %21 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%20 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %22 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%21 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %23 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%22 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.truncf %cst_50 : f64 to f32
      %209 = arith.addf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x128x1xf32>
    %24 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%23 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.rsqrt %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %25 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%24 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %26 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%19, %25 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %27 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%26, %cst_37 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %28 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%27, %cst_38 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %29 = tensor.empty() : tensor<128x128xf32>
    %30 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_35 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %31 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%30 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %32 = linalg.fill ins(%cst_46 : f32) outs(%7 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %33 = linalg.batch_matmul ins(%28, %31 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %34 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%33, %cst_36 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %35 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_33 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %36 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%35 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %37 = linalg.batch_matmul ins(%28, %36 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %38 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%37, %cst_34 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %expanded_53 = tensor.expand_shape %38 [[0], [1], [2, 3]] : tensor<2x128x128xf32> into tensor<2x128x2x64xf32>
    %39 = tensor.empty() : tensor<2x2x128x64xf32>
    %40 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_53 : tensor<2x128x2x64xf32>) outs(%39 : tensor<2x2x128x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x128x64xf32>
    %41 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_31 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %42 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%41 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %43 = linalg.batch_matmul ins(%28, %42 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %44 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%43, %cst_32 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %expanded_54 = tensor.expand_shape %44 [[0], [1], [2, 3]] : tensor<2x128x128xf32> into tensor<2x128x2x64xf32>
    %45 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_54 : tensor<2x128x2x64xf32>) outs(%39 : tensor<2x2x128x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x128x64xf32>
    %expanded_55 = tensor.expand_shape %34 [[0], [1], [2, 3]] : tensor<2x128x128xf32> into tensor<2x128x2x64xf32>
    %46 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_55 : tensor<2x128x2x64xf32>) outs(%39 : tensor<2x2x128x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x128x64xf32>
    %47 = tensor.empty() : tensor<2x2x64x128xf32>
    %48 = linalg.generic {indexing_maps = [#map3, #map13], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%40 : tensor<2x2x128x64xf32>) outs(%47 : tensor<2x2x64x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x64x128xf32>
    %collapsed = tensor.collapse_shape %46 [[0, 1], [2], [3]] : tensor<2x2x128x64xf32> into tensor<4x128x64xf32>
    %collapsed_56 = tensor.collapse_shape %48 [[0, 1], [2], [3]] : tensor<2x2x64x128xf32> into tensor<4x64x128xf32>
    %49 = tensor.empty() : tensor<4x128x128xf32>
    %50 = linalg.fill ins(%cst_46 : f32) outs(%49 : tensor<4x128x128xf32>) -> tensor<4x128x128xf32>
    %51 = linalg.batch_matmul ins(%collapsed, %collapsed_56 : tensor<4x128x64xf32>, tensor<4x64x128xf32>) outs(%50 : tensor<4x128x128xf32>) -> tensor<4x128x128xf32>
    %expanded_57 = tensor.expand_shape %51 [[0, 1], [2], [3]] : tensor<4x128x128xf32> into tensor<2x2x128x128xf32>
    %52 = tensor.empty() : tensor<2x2x128x128xf32>
    %53 = linalg.generic {indexing_maps = [#map3, #map4, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_57, %cst_30 : tensor<2x2x128x128xf32>, tensor<f64>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f64, %out: f32):
      %208 = arith.truncf %in_72 : f64 to f32
      %209 = arith.divf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x2x128x128xf32>
    %54 = linalg.generic {indexing_maps = [#map3, #map2, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%53, %6 : tensor<2x2x128x128xf32>, tensor<2x1x1x128xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %55 = tensor.empty() : tensor<2x2x128x1xi64>
    %56 = linalg.fill ins(%c0_i64 : i64) outs(%55 : tensor<2x2x128x1xi64>) -> tensor<2x2x128x1xi64>
    %57 = tensor.empty() : tensor<2x2x128x1xf32>
    %58 = linalg.fill ins(%cst_47 : f32) outs(%57 : tensor<2x2x128x1xf32>) -> tensor<2x2x128x1xf32>
    %59:2 = linalg.generic {indexing_maps = [#map3, #map14, #map14], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%54 : tensor<2x2x128x128xf32>) outs(%58, %56 : tensor<2x2x128x1xf32>, tensor<2x2x128x1xi64>) {
    ^bb0(%in: f32, %out: f32, %out_72: i64):
      %208 = linalg.index 3 : index
      %209 = arith.index_cast %208 : index to i64
      %210 = arith.maxf %in, %out : f32
      %211 = arith.cmpf ogt, %in, %out : f32
      %212 = arith.select %211, %209, %out_72 : i64
      linalg.yield %210, %212 : f32, i64
    } -> (tensor<2x2x128x1xf32>, tensor<2x2x128x1xi64>)
    %60 = linalg.generic {indexing_maps = [#map3, #map14, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%54, %59#0 : tensor<2x2x128x128xf32>, tensor<2x2x128x1xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %61 = linalg.generic {indexing_maps = [#map3, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%60 : tensor<2x2x128x128xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.exp %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %62 = linalg.fill ins(%cst_46 : f32) outs(%57 : tensor<2x2x128x1xf32>) -> tensor<2x2x128x1xf32>
    %63 = linalg.generic {indexing_maps = [#map3, #map14], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%61 : tensor<2x2x128x128xf32>) outs(%62 : tensor<2x2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x1xf32>
    %64 = linalg.generic {indexing_maps = [#map3, #map14, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%61, %63 : tensor<2x2x128x128xf32>, tensor<2x2x128x1xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.divf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %collapsed_58 = tensor.collapse_shape %64 [[0, 1], [2], [3]] : tensor<2x2x128x128xf32> into tensor<4x128x128xf32>
    %collapsed_59 = tensor.collapse_shape %45 [[0, 1], [2], [3]] : tensor<2x2x128x64xf32> into tensor<4x128x64xf32>
    %65 = tensor.empty() : tensor<4x128x64xf32>
    %66 = linalg.fill ins(%cst_46 : f32) outs(%65 : tensor<4x128x64xf32>) -> tensor<4x128x64xf32>
    %67 = linalg.batch_matmul ins(%collapsed_58, %collapsed_59 : tensor<4x128x128xf32>, tensor<4x128x64xf32>) outs(%66 : tensor<4x128x64xf32>) -> tensor<4x128x64xf32>
    %expanded_60 = tensor.expand_shape %67 [[0, 1], [2], [3]] : tensor<4x128x64xf32> into tensor<2x2x128x64xf32>
    %68 = tensor.empty() : tensor<2x128x2x64xf32>
    %69 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_60 : tensor<2x2x128x64xf32>) outs(%68 : tensor<2x128x2x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x2x64xf32>
    %collapsed_61 = tensor.collapse_shape %69 [[0], [1], [2, 3]] : tensor<2x128x2x64xf32> into tensor<2x128x128xf32>
    %70 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_28 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %71 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%70 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %72 = linalg.batch_matmul ins(%collapsed_61, %71 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %73 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%72, %cst_29 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %74 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%73, %28 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %75 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%74 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %76 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%75 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %77 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%76 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %78 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%74, %77 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %79 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%78, %78 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %80 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%79 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %81 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%80 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %82 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%81 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.truncf %cst_50 : f64 to f32
      %209 = arith.addf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x128x1xf32>
    %83 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%82 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.rsqrt %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %84 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%83 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %85 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%78, %84 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %86 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%85, %cst_26 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %87 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%86, %cst_27 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %88 = tensor.empty() : tensor<128x512xf32>
    %89 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_24 : tensor<512x128xf32>) outs(%88 : tensor<128x512xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x512xf32>
    %90 = tensor.empty() : tensor<2x128x512xf32>
    %91 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%89 : tensor<128x512xf32>) outs(%90 : tensor<2x128x512xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x512xf32>
    %92 = linalg.fill ins(%cst_46 : f32) outs(%90 : tensor<2x128x512xf32>) -> tensor<2x128x512xf32>
    %93 = linalg.batch_matmul ins(%87, %91 : tensor<2x128x128xf32>, tensor<2x128x512xf32>) outs(%92 : tensor<2x128x512xf32>) -> tensor<2x128x512xf32>
    %94 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%93, %cst_25 : tensor<2x128x512xf32>, tensor<512xf32>) outs(%90 : tensor<2x128x512xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x512xf32>
    %95 = linalg.generic {indexing_maps = [#map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%94 : tensor<2x128x512xf32>) outs(%90 : tensor<2x128x512xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_48 : f32
      %209 = math.erf %208 : f32
      %210 = arith.addf %209, %cst_45 : f32
      %211 = arith.mulf %210, %cst_49 : f32
      %212 = arith.mulf %in, %211 : f32
      linalg.yield %212 : f32
    } -> tensor<2x128x512xf32>
    %96 = tensor.empty() : tensor<512x128xf32>
    %97 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_22 : tensor<128x512xf32>) outs(%96 : tensor<512x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<512x128xf32>
    %98 = tensor.empty() : tensor<2x512x128xf32>
    %99 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%97 : tensor<512x128xf32>) outs(%98 : tensor<2x512x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x512x128xf32>
    %100 = linalg.batch_matmul ins(%95, %99 : tensor<2x128x512xf32>, tensor<2x512x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %101 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%100, %cst_23 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %102 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%101, %87 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %103 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%102 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %104 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%103 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %105 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%104 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %106 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%102, %105 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %107 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%106, %106 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %108 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%107 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %109 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%108 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %110 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%109 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.truncf %cst_50 : f64 to f32
      %209 = arith.addf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x128x1xf32>
    %111 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%110 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.rsqrt %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %112 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%111 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %113 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%106, %112 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %114 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%113, %cst_20 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %115 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%114, %cst_21 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %116 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_18 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %117 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%116 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %118 = linalg.batch_matmul ins(%115, %117 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %119 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%118, %cst_19 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %120 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_16 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %121 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%120 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %122 = linalg.batch_matmul ins(%115, %121 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %123 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%122, %cst_17 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %expanded_62 = tensor.expand_shape %123 [[0], [1], [2, 3]] : tensor<2x128x128xf32> into tensor<2x128x2x64xf32>
    %124 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_62 : tensor<2x128x2x64xf32>) outs(%39 : tensor<2x2x128x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x128x64xf32>
    %125 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_14 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %126 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%125 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %127 = linalg.batch_matmul ins(%115, %126 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %128 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%127, %cst_15 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %expanded_63 = tensor.expand_shape %128 [[0], [1], [2, 3]] : tensor<2x128x128xf32> into tensor<2x128x2x64xf32>
    %129 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_63 : tensor<2x128x2x64xf32>) outs(%39 : tensor<2x2x128x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x128x64xf32>
    %expanded_64 = tensor.expand_shape %119 [[0], [1], [2, 3]] : tensor<2x128x128xf32> into tensor<2x128x2x64xf32>
    %130 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_64 : tensor<2x128x2x64xf32>) outs(%39 : tensor<2x2x128x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x128x64xf32>
    %131 = linalg.generic {indexing_maps = [#map3, #map13], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%124 : tensor<2x2x128x64xf32>) outs(%47 : tensor<2x2x64x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x2x64x128xf32>
    %collapsed_65 = tensor.collapse_shape %130 [[0, 1], [2], [3]] : tensor<2x2x128x64xf32> into tensor<4x128x64xf32>
    %collapsed_66 = tensor.collapse_shape %131 [[0, 1], [2], [3]] : tensor<2x2x64x128xf32> into tensor<4x64x128xf32>
    %132 = linalg.batch_matmul ins(%collapsed_65, %collapsed_66 : tensor<4x128x64xf32>, tensor<4x64x128xf32>) outs(%50 : tensor<4x128x128xf32>) -> tensor<4x128x128xf32>
    %expanded_67 = tensor.expand_shape %132 [[0, 1], [2], [3]] : tensor<4x128x128xf32> into tensor<2x2x128x128xf32>
    %133 = linalg.generic {indexing_maps = [#map3, #map4, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_67, %cst_30 : tensor<2x2x128x128xf32>, tensor<f64>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f64, %out: f32):
      %208 = arith.truncf %in_72 : f64 to f32
      %209 = arith.divf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x2x128x128xf32>
    %134 = linalg.generic {indexing_maps = [#map3, #map2, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%133, %6 : tensor<2x2x128x128xf32>, tensor<2x1x1x128xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %135:2 = linalg.generic {indexing_maps = [#map3, #map14, #map14], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%134 : tensor<2x2x128x128xf32>) outs(%58, %56 : tensor<2x2x128x1xf32>, tensor<2x2x128x1xi64>) {
    ^bb0(%in: f32, %out: f32, %out_72: i64):
      %208 = linalg.index 3 : index
      %209 = arith.index_cast %208 : index to i64
      %210 = arith.maxf %in, %out : f32
      %211 = arith.cmpf ogt, %in, %out : f32
      %212 = arith.select %211, %209, %out_72 : i64
      linalg.yield %210, %212 : f32, i64
    } -> (tensor<2x2x128x1xf32>, tensor<2x2x128x1xi64>)
    %136 = linalg.generic {indexing_maps = [#map3, #map14, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%134, %135#0 : tensor<2x2x128x128xf32>, tensor<2x2x128x1xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %137 = linalg.generic {indexing_maps = [#map3, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%136 : tensor<2x2x128x128xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.exp %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %138 = linalg.generic {indexing_maps = [#map3, #map14], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%137 : tensor<2x2x128x128xf32>) outs(%62 : tensor<2x2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x1xf32>
    %139 = linalg.generic {indexing_maps = [#map3, #map14, #map3], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%137, %138 : tensor<2x2x128x128xf32>, tensor<2x2x128x1xf32>) outs(%52 : tensor<2x2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.divf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x2x128x128xf32>
    %collapsed_68 = tensor.collapse_shape %139 [[0, 1], [2], [3]] : tensor<2x2x128x128xf32> into tensor<4x128x128xf32>
    %collapsed_69 = tensor.collapse_shape %129 [[0, 1], [2], [3]] : tensor<2x2x128x64xf32> into tensor<4x128x64xf32>
    %140 = linalg.batch_matmul ins(%collapsed_68, %collapsed_69 : tensor<4x128x128xf32>, tensor<4x128x64xf32>) outs(%66 : tensor<4x128x64xf32>) -> tensor<4x128x64xf32>
    %expanded_70 = tensor.expand_shape %140 [[0, 1], [2], [3]] : tensor<4x128x64xf32> into tensor<2x2x128x64xf32>
    %141 = linalg.generic {indexing_maps = [#map3, #map12], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%expanded_70 : tensor<2x2x128x64xf32>) outs(%68 : tensor<2x128x2x64xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x2x64xf32>
    %collapsed_71 = tensor.collapse_shape %141 [[0], [1], [2, 3]] : tensor<2x128x2x64xf32> into tensor<2x128x128xf32>
    %142 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_12 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %143 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%142 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %144 = linalg.batch_matmul ins(%collapsed_71, %143 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %145 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%144, %cst_13 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %146 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%145, %115 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %147 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%146 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %148 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%147 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %149 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%148 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %150 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%146, %149 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %151 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%150, %150 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %152 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%151 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %153 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%152 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %154 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%153 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.truncf %cst_50 : f64 to f32
      %209 = arith.addf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x128x1xf32>
    %155 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%154 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.rsqrt %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %156 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%155 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %157 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%150, %156 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %158 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%157, %cst_10 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %159 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%158, %cst_11 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %160 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_8 : tensor<512x128xf32>) outs(%88 : tensor<128x512xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x512xf32>
    %161 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%160 : tensor<128x512xf32>) outs(%90 : tensor<2x128x512xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x512xf32>
    %162 = linalg.batch_matmul ins(%159, %161 : tensor<2x128x128xf32>, tensor<2x128x512xf32>) outs(%92 : tensor<2x128x512xf32>) -> tensor<2x128x512xf32>
    %163 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%162, %cst_9 : tensor<2x128x512xf32>, tensor<512xf32>) outs(%90 : tensor<2x128x512xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x512xf32>
    %164 = linalg.generic {indexing_maps = [#map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%163 : tensor<2x128x512xf32>) outs(%90 : tensor<2x128x512xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_48 : f32
      %209 = math.erf %208 : f32
      %210 = arith.addf %209, %cst_45 : f32
      %211 = arith.mulf %210, %cst_49 : f32
      %212 = arith.mulf %in, %211 : f32
      linalg.yield %212 : f32
    } -> tensor<2x128x512xf32>
    %165 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_6 : tensor<128x512xf32>) outs(%96 : tensor<512x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<512x128xf32>
    %166 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%165 : tensor<512x128xf32>) outs(%98 : tensor<2x512x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x512x128xf32>
    %167 = linalg.batch_matmul ins(%164, %166 : tensor<2x128x512xf32>, tensor<2x512x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %168 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%167, %cst_7 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %169 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%168, %159 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %170 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%169 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %171 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%170 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %172 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%171 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %173 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%169, %172 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %174 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%173, %173 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %175 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%174 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %176 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%175 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %177 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%176 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.truncf %cst_50 : f64 to f32
      %209 = arith.addf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x128x1xf32>
    %178 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%177 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.rsqrt %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %179 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%178 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %180 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%173, %179 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %181 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%180, %cst_4 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %182 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%181, %cst_5 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %183 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_1 : tensor<128x128xf32>) outs(%29 : tensor<128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x128xf32>
    %184 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%183 : tensor<128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %185 = linalg.batch_matmul ins(%182, %184 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%32 : tensor<2x128x128xf32>) -> tensor<2x128x128xf32>
    %186 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%185, %cst_2 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %187 = linalg.generic {indexing_maps = [#map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%186 : tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_48 : f32
      %209 = math.erf %208 : f32
      %210 = arith.addf %209, %cst_45 : f32
      %211 = arith.mulf %210, %cst_49 : f32
      %212 = arith.mulf %in, %211 : f32
      linalg.yield %212 : f32
    } -> tensor<2x128x128xf32>
    %188 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%187 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %189 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%188 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %190 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%189 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %191 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%187, %190 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.subf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %192 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%191, %191 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %193 = linalg.generic {indexing_maps = [#map6, #map8], iterator_types = ["parallel", "parallel", "reduction"]} ins(%192 : tensor<2x128x128xf32>) outs(%15 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.addf %in, %out : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %194 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%193 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.divf %in, %cst_51 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %195 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%194 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = arith.truncf %cst_50 : f64 to f32
      %209 = arith.addf %in, %208 : f32
      linalg.yield %209 : f32
    } -> tensor<2x128x1xf32>
    %196 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%195 : tensor<2x128x1xf32>) outs(%14 : tensor<2x128x1xf32>) {
    ^bb0(%in: f32, %out: f32):
      %208 = math.rsqrt %in : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x1xf32>
    %197 = linalg.generic {indexing_maps = [#map8, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%196 : tensor<2x128x1xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x128xf32>
    %198 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%191, %197 : tensor<2x128x128xf32>, tensor<2x128x128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %199 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%198, %cst : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.mulf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %200 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%199, %cst_0 : tensor<2x128x128xf32>, tensor<128xf32>) outs(%7 : tensor<2x128x128xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x128xf32>
    %201 = tensor.empty() : tensor<128x30522xf32>
    %202 = linalg.generic {indexing_maps = [#map1, #map10], iterator_types = ["parallel", "parallel"]} ins(%cst_44 : tensor<30522x128xf32>) outs(%201 : tensor<128x30522xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<128x30522xf32>
    %203 = tensor.empty() : tensor<2x128x30522xf32>
    %204 = linalg.generic {indexing_maps = [#map11, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%202 : tensor<128x30522xf32>) outs(%203 : tensor<2x128x30522xf32>) {
    ^bb0(%in: f32, %out: f32):
      linalg.yield %in : f32
    } -> tensor<2x128x30522xf32>
    %205 = linalg.fill ins(%cst_46 : f32) outs(%203 : tensor<2x128x30522xf32>) -> tensor<2x128x30522xf32>
    %206 = linalg.batch_matmul ins(%200, %204 : tensor<2x128x128xf32>, tensor<2x128x30522xf32>) outs(%205 : tensor<2x128x30522xf32>) -> tensor<2x128x30522xf32>
    %207 = linalg.generic {indexing_maps = [#map6, #map9, #map6], iterator_types = ["parallel", "parallel", "parallel"]} ins(%206, %cst_3 : tensor<2x128x30522xf32>, tensor<30522xf32>) outs(%203 : tensor<2x128x30522xf32>) {
    ^bb0(%in: f32, %in_72: f32, %out: f32):
      %208 = arith.addf %in, %in_72 : f32
      linalg.yield %208 : f32
    } -> tensor<2x128x30522xf32>
    return %207 : tensor<2x128x30522xf32>
  }
}
