#!/bin/bash
ARCH=$(arch) 
TARGET="nvim-ide"
BUILDER="docker"

if ! command -v $BUILDER &> /dev/null
then
    BUILDER="podman"
fi

if [ "ARCH" = "arm64" ]; then
   ARCH2="arm64"
fi

echo "using arch $ARCH"
if [ $ARCH = "arm64" ]
then
    $BUILDER build --build-arg ARCH=''$ARCH'v8' -t $TARGET:$ARCH-latest -f ./Dockerfile .
else
    $BUILDER build --format docker --build-arg ARCH=$ARCH -t $TARGET:$ARCH-latest -f ./Dockerfile .
fi
