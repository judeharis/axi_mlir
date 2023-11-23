#!/usr/bin/python3
import argparse
import itertools
import os
import generator

# tinybert

## the following variables define a problem put into an array
# problems = [[1, 7, 8, 5, 2, 2]]
# problems = [[1, 7, 3, 3, 2, 2]]
# problems = [[1, 7, 2 , 3, 2, 2]]
problems = [[1, 7, 4, 3, 8, 2]]
# problems = [[1, 5, 2, 3, 2, 1]]



# [b,iwh,ic,fwh,oc,st]p
# resnet18
layer_0 = [1, 230, 3, 7, 64, 2, "Valid", 112]
layer_1 = [1, 58, 64, 3, 64, 1, "Same", 56]
layer_2 = [1, 56, 64, 1, 128, 2, "Same", 28]
layer_3 = [1, 58, 64, 3, 128, 2, "Valid", 28]
layer_4 = [1, 30, 128, 3, 128, 1, "Same", 28]
layer_5 = [1, 28, 128, 1, 256, 2, "Same", 14]
layer_6 = [1, 30, 128, 3, 256, 2, "Valid", 14]
layer_7 = [1, 16, 256, 3, 256, 1, "Same", 14]
layer_8 = [1, 14, 256, 1, 512, 2, "Same", 7]
layer_9 = [1, 16, 256, 3, 512, 2, "Valid", 7]
layer_10 = [1, 9, 512, 3, 512, 1, "Same", 7]


layer_test_st1 = [1, 7, 8, 3, 2, 1, "Valid"]
layer_test_st2 = [1, 7, 8, 3, 2, 2, "Valid"]
test_st1 = [1, 7, 1, 3, 2, 1, "Valid"]
test_st2 = [1, 7, 2, 3, 2, 1, "Valid"]

test_st2 = [1, 7, 256, 3, 64, 1, "Valid"]



problems = [
layer_0,
layer_1,
layer_2,
layer_3,
layer_4,
layer_5,
layer_6,
layer_7,
layer_8,
layer_9,
layer_10,
]

tag_array = []
b_array = []
ihw_array = []
ic_array = []
fhw_array = []
oc_array = []
st_array = []
lang_array = []
target_array = []
accel_name_array = []
dataflow_array = []
mlir_call = []
iwh_ihw_array = []
fhw_fhw_array = []
ohw_ohw_array = []
ihw_ihw_ic_array = []
fhw_fhw_ic_array = []
fhw_fhw_oc_array = []
ohw_ohw_oc_array = []


def process(id, dims, lang, target, accel_name, dataflow, args):
    tag = f"B{dims[0]}_IHW{dims[1]}_IC{dims[2]}_FHW{dims[3]}_OC{dims[4]}_ST{dims[5]}-{lang}-{target}-{accel_name}-{dataflow}"
    tag_array.append(tag)
    b_array.append(dims[0])
    ihw_array.append(dims[1])
    ic_array.append(dims[2])
    fhw_array.append(dims[3])
    oc_array.append(dims[4])
    st_array.append(dims[5])
    lang_array.append(lang)
    target_array.append(target)
    accel_name_array.append(accel_name)
    dataflow_array.append(dataflow)
    ohw = ((dims[1] - dims[3]) // dims[5]) + 1
    ohw_ohw_array.append(ohw)

    ihw = dims[1]
    ic = dims[2]
    fhw = dims[3]
    oc = dims[4]
    st = dims[5]

    ihw_ihw_ic = ihw * ihw * ic
    fhw_fhw_ic = fhw * fhw * ic
    fhw_fhw_oc = fhw * fhw * oc
    ohw_ohw_oc = ohw * ohw * oc
    ihw_ihw = ihw * ihw
    fhw_fhw = fhw * fhw
    ohw_ohw = ohw * ohw

    mlir_call_str = "conv2d_B{}_IHW{}_IC{}_FHW{}_OC{}_ST{}_{}_{}_{}_call".format(
        dims[0],
        dims[1],
        dims[2],
        dims[3],
        dims[4],
        dims[5],
        lang,
        target,
        accel_name,
        dataflow,
    )
    mlir_call.append(mlir_call_str)
    if lang == "MLIR":
        cmdargs = "{} {} {} {} {} {} {} {} {} {} {} {} {} {} {}".format(
            dims[0],
            dims[1],
            dims[2],
            dims[3],
            dims[4],
            dims[5],
            ohw,
            ihw_ihw,
            fhw_fhw,
            ohw_ohw,
            ihw_ihw_ic,
            fhw_fhw_ic,
            fhw_fhw_oc,
            ohw_ohw_oc,
            mlir_call_str,
        ).split()
        cmdargs.append("--template")
        if target == "CPU" and args.template == "../srcs/template_mlir_conv2ds.mlir":
            cmdargs.append("../srcs/template_mlir_conv2ds_cpu_only.mlir")
        else:
            cmdargs.append(args.template)
        
        generator.main(cmdargs)


def declare_arrary(f, name, list):
    f.write("declare -a {}Array=(\n".format(name))
    for i in list:
        f.write('  "{}" \n'.format(i))
    f.write(")\n")


def main(raw_args=None):
    parser = argparse.ArgumentParser(
        description="Generate a concatenation of calls",
        epilog="Usage: ./generate_all.py --template ../srcs/template_mlir_conv2ds.mlir > ../srcs/mlir_conv2ds.mlir",
    )
    parser.add_argument(
        "--template",
        dest="template",
        type=str,
        default="template.mlir",
        help="File name of the tamplate",
    )
    args = parser.parse_args(raw_args)
    id = 0
    for dims in problems:
        process(id, dims, "MANUAL", "ACC", "v3", "Fs",args)
        process(id, dims, "MLIR", "ACC", "v3", "Fs", args)
        process(id, dims, "MLIR", "CPU", "NONE", "NONE",args)
        id += 1

    os.system("mkdir -p ../srcs")
    f = open("../srcs/array_pynq.sh", "w")
    declare_arrary(f, "Tag", tag_array)
    declare_arrary(f, "B", b_array)
    declare_arrary(f, "IHW", ihw_array)
    declare_arrary(f, "IC", ic_array)
    declare_arrary(f, "FHW", fhw_array)
    declare_arrary(f, "OC", oc_array)
    declare_arrary(f, "ST", st_array)
    declare_arrary(f, "Lang", lang_array)
    declare_arrary(f, "Target", target_array)
    declare_arrary(f, "AccelName", accel_name_array)
    declare_arrary(f, "Dataflow", dataflow_array)
    # TODO(JUDE): Missing OHW?????????
    declare_arrary(f, "IWHxIHW", iwh_ihw_array)
    declare_arrary(f, "FHWxFHW", fhw_fhw_array)
    declare_arrary(f, "OHWxOHW", ohw_ohw_array)
    declare_arrary(f, "IHWxIHWxIC", ihw_ihw_ic_array)
    declare_arrary(f, "FHWxFHWxIC", fhw_fhw_ic_array)
    declare_arrary(f, "FHWxFHWxOC", fhw_fhw_oc_array)
    declare_arrary(f, "OHWxOHWxOC", ohw_ohw_oc_array)
    declare_arrary(f, "MLIRCall", mlir_call)

    f.close()


if __name__ == "__main__":
    main()
