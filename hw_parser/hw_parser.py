import argparse
from audioop import add
import json
from operator import truediv
from re import X

import itertools
import utils as u
import dataflow as df
import df_tree as dft



def check_valid_stationary(vars_opcode, s_data):
    return len(vars_opcode[s_data]) > 0


def find_opcode_pattern(vars_opcode, s_data):
    return len(vars_opcode[s_data]) > 0


parser = argparse.ArgumentParser(description="Process hw config file")
parser.add_argument("-i", "--input", type=str, required=True)
parser.add_argument("-ic", "--input_cpu", type=str, required=True)
# parser.add_argument('-e','--extended', type=bool, required=False, default=True)
parser.add_argument("-e", "--extended", action="store_true")

parser.add_argument("-d", "--dataflow", action="store_true")
parser.add_argument("-s", "--stationary", type=int, default=0)


args = parser.parse_args()

f = open(args.input)
acc = json.load(f)

f = open(args.input_cpu)
cpu = json.load(f)
f.close()


dim_count = len(acc["dims"])
dims = [d for d in acc["dims"]]
io_data = [d for d in acc["data"]]


output_args = ""

if acc["tile_based"] == 1:
    output_args += "--accel-tile-size=" + str(acc["tile_size"]) + " "

output_args += "--element-size=" + str(acc["data_size"]) + " "
output_args += "--number-of-caches=" + str(len(cpu["CPU_cache_levels"])) + " "


output_args += "--tile-sizes="
for size in cpu["CPU_cache_levels"]:
    output_args += str(size) + "," + str(size) + "," + str(size) + ","
output_args = output_args[:-1]
output_args += " "


l1_cache_size = cpu["L1_cache_size"] * 1024
l2_cache_size = cpu["L2_cache_size"] * 1024


if args.extended:
    output_args += "--data-flow="
    df_strings = []
    for dflow in acc["dataflow"]:
        df_string = ""
        for op in dflow["flow"]:
            df_string += op["OP"] + "_" + op["data"] + "_" + str(op["length"]) + ","
        df_string = df_string[:-1]
        df_string += " "

        tiles_accessed = dflow["in_tiles"] + dflow["out_tiles"]
        if dflow["post_compute_processing"] != "accumulate":
            df_string += "--flow-cpu-accumulation "

        df_strings.append(df_string)
        l1_tile_size = l1_cache_size / (
            tiles_accessed * acc["tile_size"] ** 2 * acc["data_size"]
        )
        l2_tile_size = l2_cache_size / (
            tiles_accessed * acc["tile_size"] ** 2 * acc["data_size"]
        )
        print(l1_tile_size)
        print(l2_tile_size)

    if len(df_strings) > 0:
        output_args += df_strings[0]

InputIDMap, OutputIDMap, DataIDMap, IDDatamap = df.createIOIDMap(acc)
InstructionList = df.createInstructionList(acc, DataIDMap)
sInstructionList = df.createSInstructionList(acc, DataIDMap)
opcode_per_data = df.dataRelatedOpcodes(InstructionList, DataIDMap)
# print(InstructionList)


icmdlist, ocmdlist = df.createAllVariations(InputIDMap, OutputIDMap)
no_sdf = df.createNoStationary(icmdlist, ocmdlist)
in_sdf = df.createInputStationary(icmdlist, ocmdlist)
out_sdf = df.createOutputStationary(icmdlist, ocmdlist)

# print(InstructionList)
# print(in_sdf)
stat_data = args.stationary-1
opcode_flows=[]
if(args.stationary):
    if(stat_data in InputIDMap):
        opcode_flows = dft.bracketedToCleanVariations(in_sdf[stat_data],InstructionList)
    elif (stat_data in OutputIDMap):
        opcode_flows = dft.bracketedToCleanVariations(out_sdf[stat_data-len(InputIDMap)],InstructionList)
    else:
        for sdf in no_sdf:
            opcode_flows = opcode_flows + dft.bracketedToCleanVariations(sdf,InstructionList)
            print("Incorrect stationary choice, defaulting to No-stationary option")
else:
    for sdf in no_sdf:
        opcode_flows = opcode_flows + dft.bracketedToCleanVariations(sdf,InstructionList)
    print("Incorrect stationary choice, defaulting to No-stationary option")

if(opcode_flows==[]):
    opcode_flows = dft.bracketedToCleanVariations(no_sdf[0],InstructionList)
    print(f"Accelerator does not support {IDDatamap[stat_data]} stationary dataflow, defaulting to No-stationary option")

# print(opcode_flows)
# print(u.findleastopcodesDF(opcode_flows))

##########################################
##########################################

# Generate Outputs


# output_matmul_trait = {}
# opcode_map = {"opcode_map": str(sInstructionList)}
# indexing_maps_l = []
# for i in acc["indexing_maps"]:
#     indexing_maps_l.append(u.cmap(i["from"], i["to"], "affine"))

# indexing_maps = {"indexing_maps": indexing_maps_l}
# permutation_map = {"permutation_map": u.cmap(
#     acc["permutation_map"]["from"], acc["permutation_map"]["to"], "affine")}
# accel_dim = {"accel_dim": u.cmap(["m", "n", "k"], [acc['tile_size'],
#                                                    acc['tile_size'], acc['tile_size']])}
# iterator_types = {"iterator_types": ["parallel", "parallel", "reduction"]}
# flow_pattern = {"flow_pattern": u.findleastopcodesDF(opcode_flows)}
# init_opcodes = {"init_opcodes": "reset"}
# dma_init_config = {"dma_init_config": u.dma(acc["dma_config"])}
# output_matmul_trait = [iterator_types,
#                        flow_pattern, init_opcodes, indexing_maps, permutation_map, accel_dim, dma_init_config, opcode_map]


# # u.trait_print(output_matmul_trait)
# ret = u.trait_cmd_print(output_matmul_trait)
# print(ret)
# ret=ret.replace("\n"," ")
# print(ret)