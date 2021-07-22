#!/bin/bash
ARCH=${1:-"amd64"}
TARGET="vim-ide"
BUILDER="docker"

if ! command -v $BUILDER &> /dev/null
then
    BUILDER="podman"
fi


echo "using arch $ARCH $ARCH2"
if [ $ARCH = "arm64v8" ]
then
    $BUILDER build --build-arg ARCH=$ARCH -t $TARGET:$ARCH-latest -f ./Dockerfile .
else
    $BUILDER build --format docker --build-arg ARCH=$ARCH -t $TARGET:$ARCH-latest -f ./Dockerfile .
fi
