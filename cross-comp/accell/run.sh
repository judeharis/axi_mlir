#!/bin/bash

if [[ $1 == "" ]]; then
 echo "Error: You did not provide an argument."
 echo "  Usage:         $0 <path-to-arm-binary>"
 echo "  Usage example: $0 output/run-matmul-v1accel-mini-app"
 exit 0

fi

# Uncomment to pre-compile
# source compile.sh

# Running with qemu
qemu-arm -L /usr/arm-linux-gnueabihf $1
