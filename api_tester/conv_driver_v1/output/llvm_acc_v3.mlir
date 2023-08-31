module attributes {llvm.data_layout = ""} {
  llvm.func @conv2d_B1_IHW7_IC2_FHW3_OC2_ST2_MLIR_ACC_v3_call(%arg0: !llvm.ptr<i32>, %arg1: !llvm.ptr<i32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: !llvm.ptr<i32>, %arg12: !llvm.ptr<i32>, %arg13: i64, %arg14: i64, %arg15: i64, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: i64, %arg22: !llvm.ptr<i32>, %arg23: !llvm.ptr<i32>, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: i64, %arg29: i64, %arg30: i64, %arg31: i64, %arg32: i64) {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(2 : index) : i64
    %3 = llvm.mlir.constant(3 : index) : i64
    llvm.br ^bb1(%0 : i64)
  ^bb1(%4: i64):  // 2 preds: ^bb0, ^bb20
    %5 = llvm.icmp "slt" %4, %1 : i64
    llvm.cond_br %5, ^bb2, ^bb21
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%0 : i64)
  ^bb3(%6: i64):  // 2 preds: ^bb2, ^bb19
    %7 = llvm.icmp "slt" %6, %2 : i64
    llvm.cond_br %7, ^bb4, ^bb20
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%0 : i64)
  ^bb5(%8: i64):  // 2 preds: ^bb4, ^bb18
    %9 = llvm.icmp "slt" %8, %3 : i64
    llvm.cond_br %9, ^bb6, ^bb19
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%0 : i64)
  ^bb7(%10: i64):  // 2 preds: ^bb6, ^bb17
    %11 = llvm.icmp "slt" %10, %3 : i64
    llvm.cond_br %11, ^bb8, ^bb18
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%0 : i64)
  ^bb9(%12: i64):  // 2 preds: ^bb8, ^bb16
    %13 = llvm.icmp "slt" %12, %2 : i64
    llvm.cond_br %13, ^bb10, ^bb17
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%0 : i64)
  ^bb11(%14: i64):  // 2 preds: ^bb10, ^bb15
    %15 = llvm.icmp "slt" %14, %3 : i64
    llvm.cond_br %15, ^bb12, ^bb16
  ^bb12:  // pred: ^bb11
    llvm.br ^bb13(%0 : i64)
  ^bb13(%16: i64):  // 2 preds: ^bb12, ^bb14
    %17 = llvm.icmp "slt" %16, %3 : i64
    llvm.cond_br %17, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %18 = llvm.mul %8, %2  : i64
    %19 = llvm.add %18, %14  : i64
    %20 = llvm.mul %10, %2  : i64
    %21 = llvm.add %20, %16  : i64
    %22 = llvm.mlir.constant(98 : index) : i64
    %23 = llvm.mul %4, %22  : i64
    %24 = llvm.mlir.constant(49 : index) : i64
    %25 = llvm.mul %12, %24  : i64
    %26 = llvm.add %23, %25  : i64
    %27 = llvm.mlir.constant(7 : index) : i64
    %28 = llvm.mul %19, %27  : i64
    %29 = llvm.add %26, %28  : i64
    %30 = llvm.add %29, %21  : i64
    %31 = llvm.getelementptr %arg1[%30] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %32 = llvm.load %31 : !llvm.ptr<i32>
    %33 = llvm.mlir.constant(18 : index) : i64
    %34 = llvm.mul %6, %33  : i64
    %35 = llvm.mlir.constant(9 : index) : i64
    %36 = llvm.mul %12, %35  : i64
    %37 = llvm.add %34, %36  : i64
    %38 = llvm.mlir.constant(3 : index) : i64
    %39 = llvm.mul %14, %38  : i64
    %40 = llvm.add %37, %39  : i64
    %41 = llvm.add %40, %16  : i64
    %42 = llvm.getelementptr %arg12[%41] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %43 = llvm.load %42 : !llvm.ptr<i32>
    %44 = llvm.mlir.constant(18 : index) : i64
    %45 = llvm.mul %4, %44  : i64
    %46 = llvm.mlir.constant(9 : index) : i64
    %47 = llvm.mul %6, %46  : i64
    %48 = llvm.add %45, %47  : i64
    %49 = llvm.mlir.constant(3 : index) : i64
    %50 = llvm.mul %8, %49  : i64
    %51 = llvm.add %48, %50  : i64
    %52 = llvm.add %51, %10  : i64
    %53 = llvm.getelementptr %arg23[%52] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %54 = llvm.load %53 : !llvm.ptr<i32>
    %55 = llvm.mul %32, %43  : i32
    %56 = llvm.add %54, %55  : i32
    %57 = llvm.mlir.constant(18 : index) : i64
    %58 = llvm.mul %4, %57  : i64
    %59 = llvm.mlir.constant(9 : index) : i64
    %60 = llvm.mul %6, %59  : i64
    %61 = llvm.add %58, %60  : i64
    %62 = llvm.mlir.constant(3 : index) : i64
    %63 = llvm.mul %8, %62  : i64
    %64 = llvm.add %61, %63  : i64
    %65 = llvm.add %64, %10  : i64
    %66 = llvm.getelementptr %arg23[%65] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    llvm.store %56, %66 : !llvm.ptr<i32>
    %67 = llvm.add %16, %1  : i64
    llvm.br ^bb13(%67 : i64)
  ^bb15:  // pred: ^bb13
    %68 = llvm.add %14, %1  : i64
    llvm.br ^bb11(%68 : i64)
  ^bb16:  // pred: ^bb11
    %69 = llvm.add %12, %1  : i64
    llvm.br ^bb9(%69 : i64)
  ^bb17:  // pred: ^bb9
    %70 = llvm.add %10, %1  : i64
    llvm.br ^bb7(%70 : i64)
  ^bb18:  // pred: ^bb7
    %71 = llvm.add %8, %1  : i64
    llvm.br ^bb5(%71 : i64)
  ^bb19:  // pred: ^bb5
    %72 = llvm.add %6, %1  : i64
    llvm.br ^bb3(%72 : i64)
  ^bb20:  // pred: ^bb3
    %73 = llvm.add %4, %1  : i64
    llvm.br ^bb1(%73 : i64)
  ^bb21:  // pred: ^bb1
    llvm.return
  }
  llvm.func @conv2d_B1_IHW7_IC2_FHW3_OC2_ST2_MLIR_CPU_NONE_call(%arg0: !llvm.ptr<i32>, %arg1: !llvm.ptr<i32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: !llvm.ptr<i32>, %arg12: !llvm.ptr<i32>, %arg13: i64, %arg14: i64, %arg15: i64, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: i64, %arg22: !llvm.ptr<i32>, %arg23: !llvm.ptr<i32>, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: i64, %arg29: i64, %arg30: i64, %arg31: i64, %arg32: i64) {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(2 : index) : i64
    %3 = llvm.mlir.constant(3 : index) : i64
    llvm.br ^bb1(%0 : i64)
  ^bb1(%4: i64):  // 2 preds: ^bb0, ^bb20
    %5 = llvm.icmp "slt" %4, %1 : i64
    llvm.cond_br %5, ^bb2, ^bb21
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%0 : i64)
  ^bb3(%6: i64):  // 2 preds: ^bb2, ^bb19
    %7 = llvm.icmp "slt" %6, %2 : i64
    llvm.cond_br %7, ^bb4, ^bb20
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%0 : i64)
  ^bb5(%8: i64):  // 2 preds: ^bb4, ^bb18
    %9 = llvm.icmp "slt" %8, %3 : i64
    llvm.cond_br %9, ^bb6, ^bb19
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%0 : i64)
  ^bb7(%10: i64):  // 2 preds: ^bb6, ^bb17
    %11 = llvm.icmp "slt" %10, %3 : i64
    llvm.cond_br %11, ^bb8, ^bb18
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%0 : i64)
  ^bb9(%12: i64):  // 2 preds: ^bb8, ^bb16
    %13 = llvm.icmp "slt" %12, %2 : i64
    llvm.cond_br %13, ^bb10, ^bb17
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%0 : i64)
  ^bb11(%14: i64):  // 2 preds: ^bb10, ^bb15
    %15 = llvm.icmp "slt" %14, %3 : i64
    llvm.cond_br %15, ^bb12, ^bb16
  ^bb12:  // pred: ^bb11
    llvm.br ^bb13(%0 : i64)
  ^bb13(%16: i64):  // 2 preds: ^bb12, ^bb14
    %17 = llvm.icmp "slt" %16, %3 : i64
    llvm.cond_br %17, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %18 = llvm.mul %8, %2  : i64
    %19 = llvm.add %18, %14  : i64
    %20 = llvm.mul %10, %2  : i64
    %21 = llvm.add %20, %16  : i64
    %22 = llvm.mlir.constant(98 : index) : i64
    %23 = llvm.mul %4, %22  : i64
    %24 = llvm.mlir.constant(49 : index) : i64
    %25 = llvm.mul %12, %24  : i64
    %26 = llvm.add %23, %25  : i64
    %27 = llvm.mlir.constant(7 : index) : i64
    %28 = llvm.mul %19, %27  : i64
    %29 = llvm.add %26, %28  : i64
    %30 = llvm.add %29, %21  : i64
    %31 = llvm.getelementptr %arg1[%30] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %32 = llvm.load %31 : !llvm.ptr<i32>
    %33 = llvm.mlir.constant(18 : index) : i64
    %34 = llvm.mul %6, %33  : i64
    %35 = llvm.mlir.constant(9 : index) : i64
    %36 = llvm.mul %12, %35  : i64
    %37 = llvm.add %34, %36  : i64
    %38 = llvm.mlir.constant(3 : index) : i64
    %39 = llvm.mul %14, %38  : i64
    %40 = llvm.add %37, %39  : i64
    %41 = llvm.add %40, %16  : i64
    %42 = llvm.getelementptr %arg12[%41] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %43 = llvm.load %42 : !llvm.ptr<i32>
    %44 = llvm.mlir.constant(18 : index) : i64
    %45 = llvm.mul %4, %44  : i64
    %46 = llvm.mlir.constant(9 : index) : i64
    %47 = llvm.mul %6, %46  : i64
    %48 = llvm.add %45, %47  : i64
    %49 = llvm.mlir.constant(3 : index) : i64
    %50 = llvm.mul %8, %49  : i64
    %51 = llvm.add %48, %50  : i64
    %52 = llvm.add %51, %10  : i64
    %53 = llvm.getelementptr %arg23[%52] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    %54 = llvm.load %53 : !llvm.ptr<i32>
    %55 = llvm.mul %32, %43  : i32
    %56 = llvm.add %54, %55  : i32
    %57 = llvm.mlir.constant(18 : index) : i64
    %58 = llvm.mul %4, %57  : i64
    %59 = llvm.mlir.constant(9 : index) : i64
    %60 = llvm.mul %6, %59  : i64
    %61 = llvm.add %58, %60  : i64
    %62 = llvm.mlir.constant(3 : index) : i64
    %63 = llvm.mul %8, %62  : i64
    %64 = llvm.add %61, %63  : i64
    %65 = llvm.add %64, %10  : i64
    %66 = llvm.getelementptr %arg23[%65] : (!llvm.ptr<i32>, i64) -> !llvm.ptr<i32>
    llvm.store %56, %66 : !llvm.ptr<i32>
    %67 = llvm.add %16, %1  : i64
    llvm.br ^bb13(%67 : i64)
  ^bb15:  // pred: ^bb13
    %68 = llvm.add %14, %1  : i64
    llvm.br ^bb11(%68 : i64)
  ^bb16:  // pred: ^bb11
    %69 = llvm.add %12, %1  : i64
    llvm.br ^bb9(%69 : i64)
  ^bb17:  // pred: ^bb9
    %70 = llvm.add %10, %1  : i64
    llvm.br ^bb7(%70 : i64)
  ^bb18:  // pred: ^bb7
    %71 = llvm.add %8, %1  : i64
    llvm.br ^bb5(%71 : i64)
  ^bb19:  // pred: ^bb5
    %72 = llvm.add %6, %1  : i64
    llvm.br ^bb3(%72 : i64)
  ^bb20:  // pred: ^bb3
    %73 = llvm.add %4, %1  : i64
    llvm.br ^bb1(%73 : i64)
  ^bb21:  // pred: ^bb1
    llvm.return
  }
}

