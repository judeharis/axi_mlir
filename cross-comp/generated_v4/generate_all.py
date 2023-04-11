#!/usr/bin/python3
import argparse
import generator
import optimal_finder as of

# problems = [[16, 512, 2048], [64, 512, 512]]
# problems = [[64, 512, 512]]
# problems = [[64, 128, 128]]
problems = [[512, 1024, 64], [64, 512, 512], [512, 256, 16], [32, 256, 1024]]
# problems = [[32, 16, 128],[16, 32, 64],[64, 16, 32],[64, 32, 16],[32, 64, 16]]

tile_sizes = [i for i in range(16, 257, 16)]
sh_before = "$PROJ_ROOT/builds/llvm-project/build-x86/bin/mlir-opt \\"
sh_after = (
    "  -cse -test-accel-to-axi4mlir \\"
    + "\n"
    + "\
  -convert-linalg-to-loops -lower-affine --buffer-loop-hoisting --buffer-deallocation \\"
    + "\n"
    + "\
  -convert-scf-to-cf \\"
    + "\n"
    + "\
  -arith-expand \\"
    + "\n"
    + "\
  -memref-expand \\"
    + "\n"
    + "\
  -convert-vector-to-llvm \\"
    + "\n"
    + '\
  -convert-memref-to-llvm="index-bitwidth=$BITW" \\'
    + "\n"
    + "\
  -convert-scf-to-cf \\"
    + "\n"
    + '\
  -convert-arith-to-llvm="index-bitwidth=$BITW" \\'
    + "\n"
    + '\
  -convert-std-to-llvm="index-bitwidth=$BITW" \\'
    + "\n"
    + "\
  -canonicalize \\"
    + "\n"
    + "\
  -reconcile-unrealized-casts \\"
    + "\n"
    + "\
  srcs/mlir_matmuls.mlir \\"
    + "\n"
    + "\
  -o $OUTDIR/llvm_acc${ACCEL_SIZE}_${ACCEL_TYPE}.mlir -print-ir-after-all 2>&1 | cat > $OUTDIR/intermediate_acc${ACCEL_SIZE}_${ACCEL_TYPE}.mlir"
    # "-print-ir-after-all 2>&1 | cat > $OUTDIR/intermediate_acc${ACCEL_SIZE}_${ACCEL_TYPE}.mlir"
)

# best = None
# for i in bests:
#     if i[1]==i[2] and i[2]==i[3]:
#         best = i
#         break
# if best == None:
#     continue
#   best = bests[0]

tag_array = []
flow_array = []
tilem_array = []
tilen_array = []
tilek_array = []
m_array = []
n_array = []
k_array = []
accelsize_array = []


def extract_best(best, id,set):
    flow = best[0]
    tile_M = best[1]
    tile_N = best[2]
    tile_K = best[3]
    dim_opcode = tile_K
    dim_opcode = dim_opcode << 10
    dim_opcode += tile_N
    dim_opcode = dim_opcode << 10
    dim_opcode += tile_M

    tag = "ACC_v4_{}s_{}_{}_{}_{}_{}".format(best[0], tile_M, tile_N, tile_K, id,set)
    perm = "0,1,2"
    opmap = f"opcode_map<s=[op_send_literal(15),op_send_literal({dim_opcode}), op_send(0), op_send(1)], r=[op_recv(2)]>"
    opflow = "(s r)"
    sizes = str(tile_M) + "," + str(tile_N) + "," + str(tile_K)
    if best[0] == "A":
        opmap = f"opcode_map<s0=[op_send_literal(1),op_send_literal({dim_opcode}), op_send(0)], s1c=[op_send_literal(14),op_send_literal({dim_opcode}), op_send(1)], r=[op_recv(2)]>"
        opflow = "(s0 (s1c r))"
        perm = "0,2,1"
        sizes = str(tile_M) + "," + str(tile_K) + "," + str(tile_N)
    elif best[0] == "B":
        opmap = f"opcode_map<s1=[op_send_literal(2),op_send_literal({dim_opcode}), op_send(1)], s0c=[op_send_literal(13),op_send_literal({dim_opcode}), op_send(0)], r=[op_recv(2)]>"
        opflow = "(s1 (s0c r))"
        perm = "1,2,0"
        sizes = str(tile_N) + "," + str(tile_K) + "," + str(tile_M)
    elif best[0] == "C":
        opmap = f"opcode_map<s=[op_send_literal(7),op_send_literal({dim_opcode}), op_send(0), op_send(1)], r=[op_send_literal(8),op_send_literal({dim_opcode}), op_recv(2)]>"
        opflow = "((s) r)"
        perm = "0,1,2"
        sizes = str(tile_M) + "," + str(tile_N) + "," + str(tile_K)
    return (sizes,tag, flow, tile_M, tile_N, tile_K, perm, opmap, opflow)


def process(best, id, dims, args, set):
    M = dims[0]
    N = dims[1]
    K = dims[2]
    if args.template == "template.mlir":
        print("Best: {}".format(best))

    (sizes,tag, flow, tile_M, tile_N, tile_K, perm, opmap, opflow) = extract_best(best, id,set)

    cmdargs = "{} {} {} {} {} {} {} {}".format(
        M,
        N,
        K,
        tag,
        perm,
        tile_M,
        tile_N,
        tile_K,
    ).split()

    cmdargs.append(opmap)
    cmdargs.append(opflow)
    cmdargs.append(sizes)
    cmdargs.append("--template")
    cmdargs.append(args.template)
    generator.main(cmdargs)
    tag_array.append(tag)
    flow_array.append(flow + "s")
    tilem_array.append(tile_M)
    tilen_array.append(tile_N)
    tilek_array.append(tile_K)
    m_array.append(M)
    n_array.append(N)
    k_array.append(K)
    accelsize_array.append(tile_M)


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
    if args.template == "srcs/template_cmd.h":
        print(sh_before)

    for dims in problems:
        M = dims[0]
        N = dims[1]
        K = dims[2]

        ball, bsa, bsb, bsc = of.get_access_count(M, N, K, tile_sizes)

        if args.template == "template.mlir":
            print("M = {}, N = {}, K = {}".format(M, N, K))

        process(ball, id, dims, args,"Optimal")
        process(bsa, id, dims, args, "Asquare")
        process(bsb, id, dims, args, "Bsquare")
        process(bsc, id, dims, args, "Csquare")
        id += 1

    if args.template == "srcs/template_cmd.h":
        print(sh_after)

    f = open("srcs/array.sh", "w")
    declare_arrary(f, "Tag", tag_array)
    declare_arrary(f, "Flow", flow_array)
    declare_arrary(f, "TileM", tilem_array)
    declare_arrary(f, "TileN", tilen_array)
    declare_arrary(f, "TileK", tilek_array)
    declare_arrary(f, "M", m_array)
    declare_arrary(f, "N", n_array)
    declare_arrary(f, "K", k_array)
    declare_arrary(f, "AccelSize", accelsize_array)
    f.close()


if __name__ == "__main__":
    main()
