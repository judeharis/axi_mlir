set -e

USER_ID=$(id -u)
GROUP_ID=$(id -g)

# These first builds use a smaller context
docker build -f ./docker/Dockerfile docker \
    --target builder -t axi4mlir/axi4mlir:latest-devel

docker build -f ./docker/Dockerfile docker \
    --target dev-user -t axi4mlir/axi4mlir:latest-devel-$USER_ID \
    --build-arg USER_ID=$USER_ID \
    --build-arg GROUP_ID=$GROUP_ID 
