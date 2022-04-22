#!/usr/bin/python3
import argparse
import generator


def main(raw_args=None):
    parser = argparse.ArgumentParser(description='Generate a concatenation of calls',
                                     epilog='Usage: ./generate_all.py 4 2 9 -t CPU MEM L2 L1 > mlir_matmuls.mlir')
    parser.add_argument('start', type=int, help='Start (or Lower Bound)')
    parser.add_argument(
        'ratio', type=int, help='Ratio (or Interval between Lower and Upper bound)')
    parser.add_argument('length', type=int, help='Length (or Upper Bound)')
    parser.add_argument('--arithmetic', action='store_true',
                        help='set arithmetic progression (default: geometric')
    parser.add_argument('--no-arithmetic', action='store_false',
                        help='uses geometric progression (this is the default')
    parser.set_defaults(arithmetic=False)
    parser.add_argument('-t', '--tags', dest='tags', action='append', nargs='+',
                        required=True, help='<Required> set of flags (separated by spaces)')
    # parser.add_argument('--template', dest='template', type=str, default='template.mlir', help='File name of the tamplate')

    args = parser.parse_args(raw_args)
    # print (args)

    dim_range = list()
    if (args.arithmetic):
        dim_range = range(args.start, args.length+1, args.ratio)
    else:
        dim_range = [args.start * args.ratio ** i for i in range(args.length)]
    for tag in args.tags[0]:
        for dim in dim_range:
            # print('{} {} {} {}'.format(dim,dim,dim, tag).split())
            generator.main('{} {} {} {}'.format(dim, dim, dim, tag).split())


if __name__ == "__main__":
    main()
