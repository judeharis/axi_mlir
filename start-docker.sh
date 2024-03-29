set -e

USER_ID=$(id -u):$(id -g)
USER=$(id -u)

DEV_IMAGE_NAME="axi4mlir/axi4mlir:latest-devel-$USER"

docker run --rm --privileged -it \
    --user=$USER_ID \
    -v ${PWD}:/working_dir -w /working_dir \
    $DEV_IMAGE_NAME \
    /bin/bash
