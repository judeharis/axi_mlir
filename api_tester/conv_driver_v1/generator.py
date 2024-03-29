#!/usr/bin/python3

import argparse
import string


def main(raw_args=None):
    parser = argparse.ArgumentParser(
        description='Generate files based on the template')

    parser.add_argument('B', type=int, help='B dim')
    parser.add_argument('IHW', type=int, help='IHW dim')
    parser.add_argument('IC', type=int, help='IC dim')
    parser.add_argument('FHW', type=int, help='FHW dim')
    parser.add_argument('OC', type=int, help='OC dim')
    parser.add_argument('ST', type=int, help='ST dim')
    parser.add_argument('OHW', type=int, help='OHW dim')
    parser.add_argument('IHWxIHW', type=int, help='IHWxIHW dim')
    parser.add_argument('FHWxFHW', type=int, help='FHWxFHW dim')
    parser.add_argument('OHWxOHW', type=int, help='OHWxOHW dim')
    parser.add_argument('IHWxIHWxIC', type=int, help='IHWxIHWxIC dim')
    parser.add_argument('FHWxFHWxIC', type=int, help='FHWxFHWxIC dim')
    parser.add_argument('FHWxFHWxOC', type=int, help='FHWxFHWxOC dim')
    parser.add_argument('OHWxOHWxOC', type=int, help='OHWxOHWxOC dim')
    parser.add_argument('MLIR_CALL', type=str, nargs='?', default='')
    parser.add_argument('--template', dest='template', type=str,
                        default='template.mlir', help='File name of the tamplate')
    
    args = parser.parse_args(raw_args)

    conv_dict = {}
    conv_dict['B'] = args.B
    conv_dict['IHW'] = args.IHW
    conv_dict['IC'] = args.IC
    conv_dict['FHW'] = args.FHW
    conv_dict['OC'] = args.OC
    conv_dict['ST'] = args.ST
    conv_dict['OHW'] = args.OHW
    conv_dict['IHWxIHW'] = args.IHWxIHW
    conv_dict['FHWxFHW'] = args.FHWxFHW
    conv_dict['OHWxOHW'] = args.OHWxOHW
    conv_dict['IHWxIHWxIC'] = args.IHWxIHWxIC
    conv_dict['FHWxFHWxIC'] = args.FHWxFHWxIC
    conv_dict['FHWxFHWxOC'] = args.FHWxFHWxOC
    conv_dict['OHWxOHWxOC'] = args.OHWxOHWxOC
    conv_dict['MLIR_CALL'] = args.MLIR_CALL



    if (args.template != 'template.mlir'):
        with open(args.template) as f:
            print(string.Template(f.read()).substitute(conv_dict))


if __name__ == "__main__":
    main()
