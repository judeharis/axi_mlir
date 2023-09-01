module attributes {llvm.data_layout = ""} {
  llvm.func @free(!llvm.ptr<i8>)
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.func @copy_from_outbuffer_i32(i64, !llvm.ptr<i8>, i32) -> i32 attributes {sym_visibility = "private"}
  llvm.func @dma_start_recv(i32, i32) -> i32 attributes {sym_visibility = "private"}
  llvm.func @dma_wait_recv() attributes {sym_visibility = "private"}
  llvm.func @copy_to_inbuffer_i32(i64, !llvm.ptr<i8>, i32) -> i32 attributes {sym_visibility = "private"}
  llvm.func @dma_start_send(i32, i32) -> i32 attributes {sym_visibility = "private"}
  llvm.func @dma_wait_send() attributes {sym_visibility = "private"}
  llvm.func @dma_init(i32, i32, i32, i32, i32) attributes {sym_visibility = "private"}
  llvm.func @dma_free() attributes {sym_visibility = "private"}
  llvm.func @conv2d_B1_IHW7_IC4_FHW3_OC8_ST1_MLIR_ACC_v3_call(%arg0: !llvm.ptr<i32>, %arg1: !llvm.ptr<i32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: !llvm.ptr<i32>, %arg12: !llvm.ptr<i32>, %arg13: i64, %arg14: i64, %arg15: i64, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: i64, %arg22: !llvm.ptr<i32>, %arg23: !llvm.ptr<i32>, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: i64, %arg29: i64, %arg30: i64, %arg31: i64, %arg32: i64) {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(8 : index) : i64
    %2 = llvm.mlir.constant(5 : index) : i64
    %3 = llvm.mlir.constant(0 : index) : i64
    %4 = llvm.mlir.constant(1077936128 : i32) : i32
    %5 = llvm.mlir.constant(369098752 : i32) : i32
    %6 = llvm.mlir.constant(65536 : i32) : i32
    %7 = llvm.mlir.constant(373293056 : i32) : i32
    %8 = llvm.mlir.constant(32 : i32) : i32
    %9 = llvm.mlir.constant(3 : i32) : i32
    %10 = llvm.mlir.constant(16 : i32) : i32
    %11 = llvm.mlir.constant(4 : i32) : i32
    %12 = llvm.mlir.constant(1 : i32) : i32
    %13 = llvm.mlir.constant(0 : i32) : i32
    %14 = llvm.mlir.constant(70 : i32) : i32
    %15 = llvm.mlir.constant(8 : i32) : i32
    %16 = llvm.mlir.constant(36 : i32) : i32
    %17 = llvm.mlir.constant(25 : i32) : i32
    llvm.call @dma_init(%4, %5, %6, %7, %6) : (i32, i32, i32, i32, i32) -> ()
    %18 = llvm.mlir.constant(1 : index) : i64
    %19 = llvm.mlir.null : !llvm.ptr<i32>
    %20 = llvm.getelementptr %19[%18] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %21 = llvm.ptrtoint %20 : !llvm.ptr<i32> to i64
    %22 = llvm.call @malloc(%21) : (i64) -> !llvm.ptr<i8>
    %23 = llvm.bitcast %22 : !llvm.ptr<i8> to !llvm.ptr<i32>
    %24 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %25 = llvm.insertvalue %23, %24[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %26 = llvm.insertvalue %23, %25[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %27 = llvm.mlir.constant(0 : index) : i64
    %28 = llvm.insertvalue %27, %26[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    llvm.store %8, %23 : !llvm.ptr<i32>
    %29 = llvm.mlir.constant(1 : index) : i64
    %30 = llvm.alloca %29 x !llvm.struct<(ptr<i32>, ptr<i32>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    llvm.store %28, %30 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    %31 = llvm.bitcast %30 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>> to !llvm.ptr<i8>
    %32 = llvm.mlir.constant(0 : index) : i64
    %33 = llvm.call @copy_to_inbuffer_i32(%32, %31, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %34 = llvm.call @dma_start_send(%12, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    llvm.call @free(%22) : (!llvm.ptr<i8>) -> ()
    %35 = llvm.mlir.constant(1 : index) : i64
    %36 = llvm.mlir.null : !llvm.ptr<i32>
    %37 = llvm.getelementptr %36[%35] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %38 = llvm.ptrtoint %37 : !llvm.ptr<i32> to i64
    %39 = llvm.call @malloc(%38) : (i64) -> !llvm.ptr<i8>
    %40 = llvm.bitcast %39 : !llvm.ptr<i8> to !llvm.ptr<i32>
    %41 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %42 = llvm.insertvalue %40, %41[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %43 = llvm.insertvalue %40, %42[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %44 = llvm.mlir.constant(0 : index) : i64
    %45 = llvm.insertvalue %44, %43[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    llvm.store %9, %40 : !llvm.ptr<i32>
    %46 = llvm.mlir.constant(1 : index) : i64
    %47 = llvm.alloca %46 x !llvm.struct<(ptr<i32>, ptr<i32>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    llvm.store %45, %47 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    %48 = llvm.bitcast %47 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>> to !llvm.ptr<i8>
    %49 = llvm.mlir.constant(0 : index) : i64
    %50 = llvm.call @copy_to_inbuffer_i32(%49, %48, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %51 = llvm.call @dma_start_send(%12, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    llvm.call @free(%39) : (!llvm.ptr<i8>) -> ()
    %52 = llvm.mlir.constant(1 : index) : i64
    %53 = llvm.mlir.null : !llvm.ptr<i32>
    %54 = llvm.getelementptr %53[%52] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %55 = llvm.ptrtoint %54 : !llvm.ptr<i32> to i64
    %56 = llvm.call @malloc(%55) : (i64) -> !llvm.ptr<i8>
    %57 = llvm.bitcast %56 : !llvm.ptr<i8> to !llvm.ptr<i32>
    %58 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %59 = llvm.insertvalue %57, %58[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %60 = llvm.insertvalue %57, %59[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %61 = llvm.mlir.constant(0 : index) : i64
    %62 = llvm.insertvalue %61, %60[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %63 = llvm.mlir.constant(1 : index) : i64
    %64 = llvm.mlir.null : !llvm.ptr<i32>
    %65 = llvm.getelementptr %64[%63] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %66 = llvm.ptrtoint %65 : !llvm.ptr<i32> to i64
    %67 = llvm.call @malloc(%66) : (i64) -> !llvm.ptr<i8>
    %68 = llvm.bitcast %67 : !llvm.ptr<i8> to !llvm.ptr<i32>
    %69 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %70 = llvm.insertvalue %68, %69[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %71 = llvm.insertvalue %68, %70[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %72 = llvm.mlir.constant(0 : index) : i64
    %73 = llvm.insertvalue %72, %71[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %74 = llvm.mlir.constant(1 : index) : i64
    %75 = llvm.mlir.null : !llvm.ptr<i32>
    %76 = llvm.getelementptr %75[%74] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %77 = llvm.ptrtoint %76 : !llvm.ptr<i32> to i64
    %78 = llvm.call @malloc(%77) : (i64) -> !llvm.ptr<i8>
    %79 = llvm.bitcast %78 : !llvm.ptr<i8> to !llvm.ptr<i32>
    %80 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %81 = llvm.insertvalue %79, %80[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %82 = llvm.insertvalue %79, %81[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %83 = llvm.mlir.constant(0 : index) : i64
    %84 = llvm.insertvalue %83, %82[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %85 = llvm.mlir.constant(1 : index) : i64
    %86 = llvm.mlir.null : !llvm.ptr<i32>
    %87 = llvm.getelementptr %86[%85] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %88 = llvm.ptrtoint %87 : !llvm.ptr<i32> to i64
    %89 = llvm.call @malloc(%88) : (i64) -> !llvm.ptr<i8>
    %90 = llvm.bitcast %89 : !llvm.ptr<i8> to !llvm.ptr<i32>
    %91 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %92 = llvm.insertvalue %90, %91[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %93 = llvm.insertvalue %90, %92[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %94 = llvm.mlir.constant(0 : index) : i64
    %95 = llvm.insertvalue %94, %93[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %96 = llvm.mlir.constant(1 : index) : i64
    %97 = llvm.mlir.null : !llvm.ptr<i32>
    %98 = llvm.getelementptr %97[%96] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %99 = llvm.ptrtoint %98 : !llvm.ptr<i32> to i64
    %100 = llvm.call @malloc(%99) : (i64) -> !llvm.ptr<i8>
    %101 = llvm.bitcast %100 : !llvm.ptr<i8> to !llvm.ptr<i32>
    %102 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %103 = llvm.insertvalue %101, %102[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %104 = llvm.insertvalue %101, %103[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    %105 = llvm.mlir.constant(0 : index) : i64
    %106 = llvm.insertvalue %105, %104[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64)>
    llvm.br ^bb1(%3 : i64)
  ^bb1(%107: i64):  // 2 preds: ^bb0, ^bb11
    %108 = llvm.icmp "slt" %107, %0 : i64
    llvm.cond_br %108, ^bb2, ^bb12
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%3 : i64)
  ^bb3(%109: i64):  // 2 preds: ^bb2, ^bb10
    %110 = llvm.icmp "slt" %109, %1 : i64
    llvm.cond_br %110, ^bb4, ^bb11
  ^bb4:  // pred: ^bb3
    llvm.store %10, %57 : !llvm.ptr<i32>
    %111 = llvm.mlir.constant(1 : index) : i64
    %112 = llvm.alloca %111 x !llvm.struct<(ptr<i32>, ptr<i32>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    llvm.store %62, %112 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    %113 = llvm.bitcast %112 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>> to !llvm.ptr<i8>
    %114 = llvm.mlir.constant(0 : index) : i64
    %115 = llvm.call @copy_to_inbuffer_i32(%114, %113, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %116 = llvm.call @dma_start_send(%12, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    llvm.store %11, %68 : !llvm.ptr<i32>
    %117 = llvm.mlir.constant(1 : index) : i64
    %118 = llvm.alloca %117 x !llvm.struct<(ptr<i32>, ptr<i32>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    llvm.store %73, %118 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    %119 = llvm.bitcast %118 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>> to !llvm.ptr<i8>
    %120 = llvm.mlir.constant(0 : index) : i64
    %121 = llvm.call @copy_to_inbuffer_i32(%120, %119, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %122 = llvm.call @dma_start_send(%12, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    llvm.store %12, %79 : !llvm.ptr<i32>
    %123 = llvm.mlir.constant(1 : index) : i64
    %124 = llvm.alloca %123 x !llvm.struct<(ptr<i32>, ptr<i32>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    llvm.store %84, %124 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    %125 = llvm.bitcast %124 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>> to !llvm.ptr<i8>
    %126 = llvm.mlir.constant(0 : index) : i64
    %127 = llvm.call @copy_to_inbuffer_i32(%126, %125, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %128 = llvm.call @dma_start_send(%12, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    %129 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %130 = llvm.insertvalue %arg11, %129[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %131 = llvm.insertvalue %arg12, %130[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %132 = llvm.mul %109, %arg18  : i64
    %133 = llvm.add %arg13, %132  : i64
    %134 = llvm.mlir.constant(0 : i64) : i64
    %135 = llvm.mul %arg19, %134  : i64
    %136 = llvm.add %133, %135  : i64
    %137 = llvm.mlir.constant(0 : i64) : i64
    %138 = llvm.mul %arg20, %137  : i64
    %139 = llvm.add %136, %138  : i64
    %140 = llvm.mlir.constant(0 : i64) : i64
    %141 = llvm.mul %arg21, %140  : i64
    %142 = llvm.add %139, %141  : i64
    %143 = llvm.insertvalue %142, %131[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %144 = llvm.mlir.constant(3 : i64) : i64
    %145 = llvm.mlir.constant(1 : i64) : i64
    %146 = llvm.insertvalue %144, %143[3, 3] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %147 = llvm.insertvalue %145, %146[4, 3] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %148 = llvm.mlir.constant(3 : i64) : i64
    %149 = llvm.mlir.constant(3 : i64) : i64
    %150 = llvm.insertvalue %148, %147[3, 2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %151 = llvm.insertvalue %149, %150[4, 2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %152 = llvm.mlir.constant(4 : i64) : i64
    %153 = llvm.mlir.constant(9 : i64) : i64
    %154 = llvm.insertvalue %152, %151[3, 1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %155 = llvm.insertvalue %153, %154[4, 1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %156 = llvm.mlir.constant(1 : i64) : i64
    %157 = llvm.mlir.constant(36 : i64) : i64
    %158 = llvm.insertvalue %156, %155[3, 0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %159 = llvm.insertvalue %157, %158[4, 0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %160 = llvm.mlir.constant(1 : index) : i64
    %161 = llvm.alloca %160 x !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>>
    llvm.store %159, %161 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>>
    %162 = llvm.bitcast %161 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>> to !llvm.ptr<i8>
    %163 = llvm.mlir.constant(4 : index) : i64
    %164 = llvm.call @copy_to_inbuffer_i32(%163, %162, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %165 = llvm.call @dma_start_send(%16, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    llvm.br ^bb5(%3 : i64)
  ^bb5(%166: i64):  // 2 preds: ^bb4, ^bb9
    %167 = llvm.icmp "slt" %166, %2 : i64
    llvm.cond_br %167, ^bb6, ^bb10
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%3 : i64)
  ^bb7(%168: i64):  // 2 preds: ^bb6, ^bb8
    %169 = llvm.icmp "slt" %168, %2 : i64
    llvm.cond_br %169, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    llvm.store %14, %90 : !llvm.ptr<i32>
    %170 = llvm.mlir.constant(1 : index) : i64
    %171 = llvm.alloca %170 x !llvm.struct<(ptr<i32>, ptr<i32>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    llvm.store %95, %171 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    %172 = llvm.bitcast %171 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>> to !llvm.ptr<i8>
    %173 = llvm.mlir.constant(0 : index) : i64
    %174 = llvm.call @copy_to_inbuffer_i32(%173, %172, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %175 = llvm.call @dma_start_send(%12, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    %176 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %177 = llvm.insertvalue %arg0, %176[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %178 = llvm.insertvalue %arg1, %177[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %179 = llvm.mlir.constant(0 : i64) : i64
    %180 = llvm.mul %arg7, %179  : i64
    %181 = llvm.add %arg2, %180  : i64
    %182 = llvm.mlir.constant(0 : i64) : i64
    %183 = llvm.mul %arg8, %182  : i64
    %184 = llvm.add %181, %183  : i64
    %185 = llvm.mul %166, %arg9  : i64
    %186 = llvm.add %184, %185  : i64
    %187 = llvm.mul %168, %arg10  : i64
    %188 = llvm.add %186, %187  : i64
    %189 = llvm.insertvalue %188, %178[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %190 = llvm.mlir.constant(3 : i64) : i64
    %191 = llvm.mlir.constant(1 : i64) : i64
    %192 = llvm.insertvalue %190, %189[3, 3] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %193 = llvm.insertvalue %191, %192[4, 3] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %194 = llvm.mlir.constant(3 : i64) : i64
    %195 = llvm.mlir.constant(7 : i64) : i64
    %196 = llvm.insertvalue %194, %193[3, 2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %197 = llvm.insertvalue %195, %196[4, 2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %198 = llvm.mlir.constant(4 : i64) : i64
    %199 = llvm.mlir.constant(49 : i64) : i64
    %200 = llvm.insertvalue %198, %197[3, 1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %201 = llvm.insertvalue %199, %200[4, 1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %202 = llvm.mlir.constant(1 : i64) : i64
    %203 = llvm.mlir.constant(196 : i64) : i64
    %204 = llvm.insertvalue %202, %201[3, 0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %205 = llvm.insertvalue %203, %204[4, 0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %206 = llvm.mlir.constant(1 : index) : i64
    %207 = llvm.alloca %206 x !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>>
    llvm.store %205, %207 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>>
    %208 = llvm.bitcast %207 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>> to !llvm.ptr<i8>
    %209 = llvm.mlir.constant(4 : index) : i64
    %210 = llvm.call @copy_to_inbuffer_i32(%209, %208, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %211 = llvm.call @dma_start_send(%16, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    %212 = llvm.add %168, %0  : i64
    llvm.br ^bb7(%212 : i64)
  ^bb9:  // pred: ^bb7
    %213 = llvm.add %166, %0  : i64
    llvm.br ^bb5(%213 : i64)
  ^bb10:  // pred: ^bb5
    llvm.store %15, %101 : !llvm.ptr<i32>
    %214 = llvm.mlir.constant(1 : index) : i64
    %215 = llvm.alloca %214 x !llvm.struct<(ptr<i32>, ptr<i32>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    llvm.store %106, %215 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>>
    %216 = llvm.bitcast %215 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64)>> to !llvm.ptr<i8>
    %217 = llvm.mlir.constant(0 : index) : i64
    %218 = llvm.call @copy_to_inbuffer_i32(%217, %216, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %219 = llvm.call @dma_start_send(%12, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_send() : () -> ()
    %220 = llvm.mlir.undef : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %221 = llvm.insertvalue %arg22, %220[0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %222 = llvm.insertvalue %arg23, %221[1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %223 = llvm.mlir.constant(0 : i64) : i64
    %224 = llvm.mul %arg29, %223  : i64
    %225 = llvm.add %arg24, %224  : i64
    %226 = llvm.mul %109, %arg30  : i64
    %227 = llvm.add %225, %226  : i64
    %228 = llvm.mlir.constant(0 : i64) : i64
    %229 = llvm.mul %arg31, %228  : i64
    %230 = llvm.add %227, %229  : i64
    %231 = llvm.mlir.constant(0 : i64) : i64
    %232 = llvm.mul %arg32, %231  : i64
    %233 = llvm.add %230, %232  : i64
    %234 = llvm.insertvalue %233, %222[2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %235 = llvm.mlir.constant(5 : i64) : i64
    %236 = llvm.mlir.constant(1 : i64) : i64
    %237 = llvm.insertvalue %235, %234[3, 3] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %238 = llvm.insertvalue %236, %237[4, 3] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %239 = llvm.mlir.constant(5 : i64) : i64
    %240 = llvm.mlir.constant(5 : i64) : i64
    %241 = llvm.insertvalue %239, %238[3, 2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %242 = llvm.insertvalue %240, %241[4, 2] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %243 = llvm.mlir.constant(1 : i64) : i64
    %244 = llvm.mlir.constant(25 : i64) : i64
    %245 = llvm.insertvalue %243, %242[3, 1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %246 = llvm.insertvalue %244, %245[4, 1] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %247 = llvm.mlir.constant(1 : i64) : i64
    %248 = llvm.mlir.constant(200 : i64) : i64
    %249 = llvm.insertvalue %247, %246[3, 0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %250 = llvm.insertvalue %248, %249[4, 0] : !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>
    %251 = llvm.mlir.constant(1 : index) : i64
    %252 = llvm.alloca %251 x !llvm.struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>>
    llvm.store %250, %252 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>>
    %253 = llvm.bitcast %252 : !llvm.ptr<struct<(ptr<i32>, ptr<i32>, i64, array<4 x i64>, array<4 x i64>)>> to !llvm.ptr<i8>
    %254 = llvm.mlir.constant(4 : index) : i64
    %255 = llvm.call @dma_start_recv(%17, %13) : (i32, i32) -> i32
    llvm.call @dma_wait_recv() : () -> ()
    %256 = llvm.call @copy_from_outbuffer_i32(%254, %253, %13) : (i64, !llvm.ptr<i8>, i32) -> i32
    %257 = llvm.add %109, %0  : i64
    llvm.br ^bb3(%257 : i64)
  ^bb11:  // pred: ^bb3
    %258 = llvm.add %107, %0  : i64
    llvm.br ^bb1(%258 : i64)
  ^bb12:  // pred: ^bb1
    llvm.call @free(%100) : (!llvm.ptr<i8>) -> ()
    llvm.call @free(%89) : (!llvm.ptr<i8>) -> ()
    llvm.call @free(%78) : (!llvm.ptr<i8>) -> ()
    llvm.call @free(%67) : (!llvm.ptr<i8>) -> ()
    llvm.call @free(%56) : (!llvm.ptr<i8>) -> ()
    llvm.call @dma_free() : () -> ()
    llvm.return
  }
  llvm.func @conv2d_B1_IHW7_IC4_FHW3_OC8_ST1_MLIR_CPU_NONE_call(%arg0: !llvm.ptr<i32>, %arg1: !llvm.ptr<i32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: !llvm.ptr<i32>, %arg12: !llvm.ptr<i32>, %arg13: i64, %arg14: i64, %arg15: i64, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: i64, %arg22: !llvm.ptr<i32>, %arg23: !llvm.ptr<i32>, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: i64, %arg29: i64, %arg30: i64, %arg31: i64, %arg32: i64) {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(8 : index) : i64
    %3 = llvm.mlir.constant(5 : index) : i64
    %4 = llvm.mlir.constant(4 : index) : i64
    %5 = llvm.mlir.constant(3 : index) : i64
    llvm.br ^bb1(%0 : i64)
  ^bb1(%6: i64):  // 2 preds: ^bb0, ^bb20
    %7 = llvm.icmp "slt" %6, %1 : i64
    llvm.cond_br %7, ^bb2, ^bb21
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%0 : i64)
  ^bb3(%8: i64):  // 2 preds: ^bb2, ^bb19
    %9 = llvm.icmp "slt" %8, %2 : i64
    llvm.cond_br %9, ^bb4, ^bb20
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%0 : i64)
  ^bb5(%10: i64):  // 2 preds: ^bb4, ^bb18
    %11 = llvm.icmp "slt" %10, %3 : i64
    llvm.cond_br %11, ^bb6, ^bb19
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%0 : i64)
  ^bb7(%12: i64):  // 2 preds: ^bb6, ^bb17
    %13 = llvm.icmp "slt" %12, %3 : i64
    llvm.cond_br %13, ^bb8, ^bb18
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%0 : i64)
  ^bb9(%14: i64):  // 2 preds: ^bb8, ^bb16
    %15 = llvm.icmp "slt" %14, %4 : i64
    llvm.cond_br %15, ^bb10, ^bb17
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%0 : i64)
  ^bb11(%16: i64):  // 2 preds: ^bb10, ^bb15
    %17 = llvm.icmp "slt" %16, %5 : i64
    llvm.cond_br %17, ^bb12, ^bb16
  ^bb12:  // pred: ^bb11
    llvm.br ^bb13(%0 : i64)
  ^bb13(%18: i64):  // 2 preds: ^bb12, ^bb14
    %19 = llvm.icmp "slt" %18, %5 : i64
    llvm.cond_br %19, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %20 = llvm.add %10, %16  : i64
    %21 = llvm.add %12, %18  : i64
    %22 = llvm.mlir.constant(196 : index) : i64
    %23 = llvm.mul %6, %22  : i64
    %24 = llvm.mlir.constant(49 : index) : i64
    %25 = llvm.mul %14, %24  : i64
    %26 = llvm.add %23, %25  : i64
    %27 = llvm.mlir.constant(7 : index) : i64
    %28 = llvm.mul %20, %27  : i64
    %29 = llvm.add %26, %28  : i64
    %30 = llvm.add %29, %21  : i64
    %31 = llvm.getelementptr %arg1[%30] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %32 = llvm.load %31 : !llvm.ptr<i32>
    %33 = llvm.mlir.constant(36 : index) : i64
    %34 = llvm.mul %8, %33  : i64
    %35 = llvm.mlir.constant(9 : index) : i64
    %36 = llvm.mul %14, %35  : i64
    %37 = llvm.add %34, %36  : i64
    %38 = llvm.mlir.constant(3 : index) : i64
    %39 = llvm.mul %16, %38  : i64
    %40 = llvm.add %37, %39  : i64
    %41 = llvm.add %40, %18  : i64
    %42 = llvm.getelementptr %arg12[%41] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %43 = llvm.load %42 : !llvm.ptr<i32>
    %44 = llvm.mlir.constant(200 : index) : i64
    %45 = llvm.mul %6, %44  : i64
    %46 = llvm.mlir.constant(25 : index) : i64
    %47 = llvm.mul %8, %46  : i64
    %48 = llvm.add %45, %47  : i64
    %49 = llvm.mlir.constant(5 : index) : i64
    %50 = llvm.mul %10, %49  : i64
    %51 = llvm.add %48, %50  : i64
    %52 = llvm.add %51, %12  : i64
    %53 = llvm.getelementptr %arg23[%52] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %54 = llvm.load %53 : !llvm.ptr<i32>
    %55 = llvm.mul %32, %43  : i32
    %56 = llvm.add %54, %55  : i32
    %57 = llvm.mlir.constant(200 : index) : i64
    %58 = llvm.mul %6, %57  : i64
    %59 = llvm.mlir.constant(25 : index) : i64
    %60 = llvm.mul %8, %59  : i64
    %61 = llvm.add %58, %60  : i64
    %62 = llvm.mlir.constant(5 : index) : i64
    %63 = llvm.mul %10, %62  : i64
    %64 = llvm.add %61, %63  : i64
    %65 = llvm.add %64, %12  : i64
    %66 = llvm.getelementptr %arg23[%65] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    llvm.store %56, %66 : !llvm.ptr<i32>
    %67 = llvm.add %18, %1  : i64
    llvm.br ^bb13(%67 : i64)
  ^bb15:  // pred: ^bb13
    %68 = llvm.add %16, %1  : i64
    llvm.br ^bb11(%68 : i64)
  ^bb16:  // pred: ^bb11
    %69 = llvm.add %14, %1  : i64
    llvm.br ^bb9(%69 : i64)
  ^bb17:  // pred: ^bb9
    %70 = llvm.add %12, %1  : i64
    llvm.br ^bb7(%70 : i64)
  ^bb18:  // pred: ^bb7
    %71 = llvm.add %10, %1  : i64
    llvm.br ^bb5(%71 : i64)
  ^bb19:  // pred: ^bb5
    %72 = llvm.add %8, %1  : i64
    llvm.br ^bb3(%72 : i64)
  ^bb20:  // pred: ^bb3
    %73 = llvm.add %6, %1  : i64
    llvm.br ^bb1(%73 : i64)
  ^bb21:  // pred: ^bb1
    llvm.return
  }
}

