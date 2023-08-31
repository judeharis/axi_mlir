module attributes {llvm.data_layout = ""} {
  llvm.func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_CPU_call(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: !llvm.ptr<f32>, %arg12: !llvm.ptr<f32>, %arg13: i64, %arg14: i64, %arg15: i64, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: i64, %arg22: !llvm.ptr<f32>, %arg23: !llvm.ptr<f32>, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: i64, %arg29: i64, %arg30: i64, %arg31: i64, %arg32: i64) {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(112 : index) : i64
    %3 = llvm.mlir.constant(64 : index) : i64
    %4 = llvm.mlir.constant(7 : index) : i64
    %5 = llvm.mlir.constant(3 : index) : i64
    %6 = llvm.mlir.constant(2 : index) : i64
    llvm.br ^bb1(%0 : i64)
  ^bb1(%7: i64):  // 2 preds: ^bb0, ^bb20
    %8 = llvm.icmp "slt" %7, %1 : i64
    llvm.cond_br %8, ^bb2, ^bb21
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%0 : i64)
  ^bb3(%9: i64):  // 2 preds: ^bb2, ^bb19
    %10 = llvm.icmp "slt" %9, %2 : i64
    llvm.cond_br %10, ^bb4, ^bb20
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%0 : i64)
  ^bb5(%11: i64):  // 2 preds: ^bb4, ^bb18
    %12 = llvm.icmp "slt" %11, %2 : i64
    llvm.cond_br %12, ^bb6, ^bb19
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%0 : i64)
  ^bb7(%13: i64):  // 2 preds: ^bb6, ^bb17
    %14 = llvm.icmp "slt" %13, %3 : i64
    llvm.cond_br %14, ^bb8, ^bb18
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%0 : i64)
  ^bb9(%15: i64):  // 2 preds: ^bb8, ^bb16
    %16 = llvm.icmp "slt" %15, %4 : i64
    llvm.cond_br %16, ^bb10, ^bb17
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%0 : i64)
  ^bb11(%17: i64):  // 2 preds: ^bb10, ^bb15
    %18 = llvm.icmp "slt" %17, %4 : i64
    llvm.cond_br %18, ^bb12, ^bb16
  ^bb12:  // pred: ^bb11
    llvm.br ^bb13(%0 : i64)
  ^bb13(%19: i64):  // 2 preds: ^bb12, ^bb14
    %20 = llvm.icmp "slt" %19, %5 : i64
    llvm.cond_br %20, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %21 = llvm.mul %9, %6  : i64
    %22 = llvm.add %21, %15  : i64
    %23 = llvm.mul %11, %6  : i64
    %24 = llvm.add %23, %17  : i64
    %25 = llvm.mlir.constant(158700 : index) : i64
    %26 = llvm.mul %7, %25  : i64
    %27 = llvm.mlir.constant(690 : index) : i64
    %28 = llvm.mul %22, %27  : i64
    %29 = llvm.add %26, %28  : i64
    %30 = llvm.mlir.constant(3 : index) : i64
    %31 = llvm.mul %24, %30  : i64
    %32 = llvm.add %29, %31  : i64
    %33 = llvm.add %32, %19  : i64
    %34 = llvm.getelementptr %arg1[%33] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %35 = llvm.load %34 : !llvm.ptr<f32>
    %36 = llvm.mlir.constant(1344 : index) : i64
    %37 = llvm.mul %15, %36  : i64
    %38 = llvm.mlir.constant(192 : index) : i64
    %39 = llvm.mul %17, %38  : i64
    %40 = llvm.add %37, %39  : i64
    %41 = llvm.mlir.constant(64 : index) : i64
    %42 = llvm.mul %19, %41  : i64
    %43 = llvm.add %40, %42  : i64
    %44 = llvm.add %43, %13  : i64
    %45 = llvm.getelementptr %arg12[%44] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %46 = llvm.load %45 : !llvm.ptr<f32>
    %47 = llvm.mlir.constant(802816 : index) : i64
    %48 = llvm.mul %7, %47  : i64
    %49 = llvm.mlir.constant(7168 : index) : i64
    %50 = llvm.mul %9, %49  : i64
    %51 = llvm.add %48, %50  : i64
    %52 = llvm.mlir.constant(64 : index) : i64
    %53 = llvm.mul %11, %52  : i64
    %54 = llvm.add %51, %53  : i64
    %55 = llvm.add %54, %13  : i64
    %56 = llvm.getelementptr %arg23[%55] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %57 = llvm.load %56 : !llvm.ptr<f32>
    %58 = llvm.fmul %35, %46  : f32
    %59 = llvm.fadd %57, %58  : f32
    %60 = llvm.mlir.constant(802816 : index) : i64
    %61 = llvm.mul %7, %60  : i64
    %62 = llvm.mlir.constant(7168 : index) : i64
    %63 = llvm.mul %9, %62  : i64
    %64 = llvm.add %61, %63  : i64
    %65 = llvm.mlir.constant(64 : index) : i64
    %66 = llvm.mul %11, %65  : i64
    %67 = llvm.add %64, %66  : i64
    %68 = llvm.add %67, %13  : i64
    %69 = llvm.getelementptr %arg23[%68] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %59, %69 : !llvm.ptr<f32>
    %70 = llvm.add %19, %1  : i64
    llvm.br ^bb13(%70 : i64)
  ^bb15:  // pred: ^bb13
    %71 = llvm.add %17, %1  : i64
    llvm.br ^bb11(%71 : i64)
  ^bb16:  // pred: ^bb11
    %72 = llvm.add %15, %1  : i64
    llvm.br ^bb9(%72 : i64)
  ^bb17:  // pred: ^bb9
    %73 = llvm.add %13, %1  : i64
    llvm.br ^bb7(%73 : i64)
  ^bb18:  // pred: ^bb7
    %74 = llvm.add %11, %1  : i64
    llvm.br ^bb5(%74 : i64)
  ^bb19:  // pred: ^bb5
    %75 = llvm.add %9, %1  : i64
    llvm.br ^bb3(%75 : i64)
  ^bb20:  // pred: ^bb3
    %76 = llvm.add %7, %1  : i64
    llvm.br ^bb1(%76 : i64)
  ^bb21:  // pred: ^bb1
    llvm.return
  }
  llvm.func @conv2d_B1_IHW230_IC3_FHW7_OC64_ST2_ACC_v3_Fs_call(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: !llvm.ptr<f32>, %arg12: !llvm.ptr<f32>, %arg13: i64, %arg14: i64, %arg15: i64, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64, %arg21: i64, %arg22: !llvm.ptr<f32>, %arg23: !llvm.ptr<f32>, %arg24: i64, %arg25: i64, %arg26: i64, %arg27: i64, %arg28: i64, %arg29: i64, %arg30: i64, %arg31: i64, %arg32: i64) {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(112 : index) : i64
    %3 = llvm.mlir.constant(64 : index) : i64
    %4 = llvm.mlir.constant(7 : index) : i64
    %5 = llvm.mlir.constant(3 : index) : i64
    %6 = llvm.mlir.constant(2 : index) : i64
    llvm.br ^bb1(%0 : i64)
  ^bb1(%7: i64):  // 2 preds: ^bb0, ^bb20
    %8 = llvm.icmp "slt" %7, %1 : i64
    llvm.cond_br %8, ^bb2, ^bb21
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%0 : i64)
  ^bb3(%9: i64):  // 2 preds: ^bb2, ^bb19
    %10 = llvm.icmp "slt" %9, %2 : i64
    llvm.cond_br %10, ^bb4, ^bb20
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%0 : i64)
  ^bb5(%11: i64):  // 2 preds: ^bb4, ^bb18
    %12 = llvm.icmp "slt" %11, %2 : i64
    llvm.cond_br %12, ^bb6, ^bb19
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%0 : i64)
  ^bb7(%13: i64):  // 2 preds: ^bb6, ^bb17
    %14 = llvm.icmp "slt" %13, %3 : i64
    llvm.cond_br %14, ^bb8, ^bb18
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%0 : i64)
  ^bb9(%15: i64):  // 2 preds: ^bb8, ^bb16
    %16 = llvm.icmp "slt" %15, %4 : i64
    llvm.cond_br %16, ^bb10, ^bb17
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%0 : i64)
  ^bb11(%17: i64):  // 2 preds: ^bb10, ^bb15
    %18 = llvm.icmp "slt" %17, %4 : i64
    llvm.cond_br %18, ^bb12, ^bb16
  ^bb12:  // pred: ^bb11
    llvm.br ^bb13(%0 : i64)
  ^bb13(%19: i64):  // 2 preds: ^bb12, ^bb14
    %20 = llvm.icmp "slt" %19, %5 : i64
    llvm.cond_br %20, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %21 = llvm.mul %9, %6  : i64
    %22 = llvm.add %21, %15  : i64
    %23 = llvm.mul %11, %6  : i64
    %24 = llvm.add %23, %17  : i64
    %25 = llvm.mlir.constant(158700 : index) : i64
    %26 = llvm.mul %7, %25  : i64
    %27 = llvm.mlir.constant(690 : index) : i64
    %28 = llvm.mul %22, %27  : i64
    %29 = llvm.add %26, %28  : i64
    %30 = llvm.mlir.constant(3 : index) : i64
    %31 = llvm.mul %24, %30  : i64
    %32 = llvm.add %29, %31  : i64
    %33 = llvm.add %32, %19  : i64
    %34 = llvm.getelementptr %arg1[%33] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %35 = llvm.load %34 : !llvm.ptr<f32>
    %36 = llvm.mlir.constant(1344 : index) : i64
    %37 = llvm.mul %15, %36  : i64
    %38 = llvm.mlir.constant(192 : index) : i64
    %39 = llvm.mul %17, %38  : i64
    %40 = llvm.add %37, %39  : i64
    %41 = llvm.mlir.constant(64 : index) : i64
    %42 = llvm.mul %19, %41  : i64
    %43 = llvm.add %40, %42  : i64
    %44 = llvm.add %43, %13  : i64
    %45 = llvm.getelementptr %arg12[%44] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %46 = llvm.load %45 : !llvm.ptr<f32>
    %47 = llvm.mlir.constant(802816 : index) : i64
    %48 = llvm.mul %7, %47  : i64
    %49 = llvm.mlir.constant(7168 : index) : i64
    %50 = llvm.mul %9, %49  : i64
    %51 = llvm.add %48, %50  : i64
    %52 = llvm.mlir.constant(64 : index) : i64
    %53 = llvm.mul %11, %52  : i64
    %54 = llvm.add %51, %53  : i64
    %55 = llvm.add %54, %13  : i64
    %56 = llvm.getelementptr %arg23[%55] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %57 = llvm.load %56 : !llvm.ptr<f32>
    %58 = llvm.fmul %35, %46  : f32
    %59 = llvm.fadd %57, %58  : f32
    %60 = llvm.mlir.constant(802816 : index) : i64
    %61 = llvm.mul %7, %60  : i64
    %62 = llvm.mlir.constant(7168 : index) : i64
    %63 = llvm.mul %9, %62  : i64
    %64 = llvm.add %61, %63  : i64
    %65 = llvm.mlir.constant(64 : index) : i64
    %66 = llvm.mul %11, %65  : i64
    %67 = llvm.add %64, %66  : i64
    %68 = llvm.add %67, %13  : i64
    %69 = llvm.getelementptr %arg23[%68] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %59, %69 : !llvm.ptr<f32>
    %70 = llvm.add %19, %1  : i64
    llvm.br ^bb13(%70 : i64)
  ^bb15:  // pred: ^bb13
    %71 = llvm.add %17, %1  : i64
    llvm.br ^bb11(%71 : i64)
  ^bb16:  // pred: ^bb11
    %72 = llvm.add %15, %1  : i64
    llvm.br ^bb9(%72 : i64)
  ^bb17:  // pred: ^bb9
    %73 = llvm.add %13, %1  : i64
    llvm.br ^bb7(%73 : i64)
  ^bb18:  // pred: ^bb7
    %74 = llvm.add %11, %1  : i64
    llvm.br ^bb5(%74 : i64)
  ^bb19:  // pred: ^bb5
    %75 = llvm.add %9, %1  : i64
    llvm.br ^bb3(%75 : i64)
  ^bb20:  // pred: ^bb3
    %76 = llvm.add %7, %1  : i64
    llvm.br ^bb1(%76 : i64)
  ^bb21:  // pred: ^bb1
    llvm.return
  }
}

