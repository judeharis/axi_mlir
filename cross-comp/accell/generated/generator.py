#!/usr/bin/python3

import argparse
import string; 

def main(raw_args=None):
  parser = argparse.ArgumentParser(description='Generate files based on the template')
  parser.add_argument('M', type=int, help='M dim')
  parser.add_argument('N', type=int, help='N dim')
  parser.add_argument('K', type=int, help='K dim')
  parser.add_argument('TAG', type=str, nargs='?', default='L1', help='Tag to mark matmul for conversion. Options=NONE, MEM, L2, L1')
  parser.add_argument('--template', dest='template', type=str, default='template.mlir', help='File name of the tamplate')

  args = parser.parse_args(raw_args)

  conv_dict = {}
  conv_dict['MVAL']=args.M
  conv_dict['NVAL']=args.N
  conv_dict['KVAL']=args.K
  conv_dict['TAG']=args.TAG

  with open(args.template) as f:
    print(string.Template(f.read()).substitute(conv_dict))

if __name__ == "__main__":
    main()