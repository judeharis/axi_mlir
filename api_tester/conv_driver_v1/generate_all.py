#!/usr/bin/python3
import argparse
import itertools


# tinybert

## the following variables define a problem put into an array
# problems = [[1, 7, 8, 5, 2, 2]]
# problems = [[1, 7, 3, 3, 2, 2]]



# [b,iwh,ic,fwh,oc,st]
# resnet18
layer_0 = [1,230,3,7,64,2,'Valid',112]
# layer_1 = [1,58,64,3,64,1,'Same',56]
# layer_2 = [1,56,64,1,128,2,'Same',28]
# layer_3 = [1,58,64,3,128,2,'Valid',28]
# layer_4 = [1,30,128,3,128,1,'Same',28]
# layer_5 = [1,28,128,1,256,2,'Same',14]
# layer_6 = [1,30,128,3,256,2,'Valid',14]
# layer_7 = [1,16,256,3,256,1,'Same',14]
# layer_8 = [1,14,256,1,512,2,'Same',7]
# layer_9 = [1,16,256,3,512,2,'Valid',7]
# layer_10 = [1,9,512,3,512,1,'Same',7]

problems = [
    layer_0,
#     layer_1,
#     layer_2,
#     layer_3,
#     layer_4,
#     layer_5,
#     layer_6,
#     layer_7,
#     layer_8,
#     layer_9,
#     layer_10,
]

tag_array = []
b_array = []
ihw_array = []
ic_array = []
fhw_array = []
oc_array = []
st_array = []


def process(id, dims, strategy):
    tag = f"B{dims[0]}_IHW{dims[1]}_IC{dims[2]}_FHW{dims[3]}_OC{dims[4]}_ST{dims[5]}-{strategy}"
    tag_array.append(tag) 
    b_array.append(dims[0])
    ihw_array.append(dims[1])
    ic_array.append(dims[2])
    fhw_array.append(dims[3])
    oc_array.append(dims[4])
    st_array.append(dims[5])


def declare_arrary(f, name, list):
    f.write("declare -a {}Array=(\n".format(name))
    for i in list:
        f.write('  "{}" \n'.format(i))
    f.write(")\n")


def main(raw_args=None):
    parser = argparse.ArgumentParser(
        description="Generate a concatenation of calls",
        epilog="Usage: ./generate_all.py 4 2 9 -t CPU MEM L2 L1 > srcs/mlir_matmuls.mlir",
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
        process(id, dims, "MANUAL_ACC-CONV_v3-Fs")
        process(id, dims, "MLIR_CPU-NONE-NONE")
        process(id, dims, "MLIR_ACC-CONV_v3-Fs")

        id += 1

    f = open("generated/array.sh", "w")
    declare_arrary(f, "Tag", tag_array)
    declare_arrary(f, "B", b_array)
    declare_arrary(f, "IHW", ihw_array)
    declare_arrary(f, "IC", ic_array)
    declare_arrary(f, "FHW", fhw_array)
    declare_arrary(f, "OC", oc_array)
    declare_arrary(f, "ST", st_array)
    f.close()


if __name__ == "__main__":
    main()
