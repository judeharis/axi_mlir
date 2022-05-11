#!/usr/bin/python3
from pynq import Overlay
import argparse
import os

def main(raw_args=None):
  parser = argparse.ArgumentParser(description='Wrapper to load valid bitstreams')
                                     
  parser.add_argument(dest='bitstream', type=str,
    default='/home/xilinx/pynq/overlays/axi4mlir/hmm_acc_4x4v1.bit', 
    help='Path to the bitstream file')

  args = parser.parse_args(raw_args)

  if os.path.isfile(args.bitstream):
    print("Loading bitistream: {}".format(args.bitstream))
    overlay = Overlay(args.bitstream)
    print(overlay.ip_dict.keys())
  else:
    print("Error! Could not find file: {}".format(args.bitstream))
    return -1

if __name__ == "__main__":
    main()