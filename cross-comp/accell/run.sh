#!/bin/bash

source compile.sh

# Running with qemu
qemu-arm -L /usr/arm-linux-gnueabihf ./app
