#!/usr/bin/python3
import argparse
import itertools


#tinybert

## the following variables define a problem put into an array
problems = [[1, 7, 8, 5, 2, 1]]

tag_array = []
b_array = []
ihw_array = []
ic_array = []
fhw_array = []
oc_array = []
st_array = []


def process(id,dims,strategy):
    tag = f"{id}_B{dims[0]}_IHW{dims[1]}_IC{dims[2]}_FHW{dims[3]}_OC{dims[4]}_ST{dims[5]}_{strategy}"
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
        process(id,dims,"MANUAL")
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
