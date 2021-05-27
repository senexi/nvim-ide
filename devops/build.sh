#!/bin/bash
ARCH=${1:-"amd64"}
ARCH2=${2:-"x86_64"}
ARCH3=$ARCH
TARGET="devops-ide"
BUILDER="docker"

if ! command -v $BUILDER &> /dev/null
then
    BUILDER="podman"
fi


if [ $ARCH = "arm64v8" ]
then
  ARCH2="aarch64"
  ARCH3="arm64"
fi

echo "using arch $ARCH $ARCH2"
#$BUILDER build --no-cache=true --build-arg ARCH=$ARCH --build-arg ARCH2=$ARCH2  -t $TARGET:$ARCH-latest -f ./Containerfile .
$BUILDER build --format docker --build-arg ARCH=$ARCH --build-arg ARCH2=$ARCH2 --build-arg ARCH3=$ARCH3 -t $TARGET:$ARCH-latest -f ./Containerfile .
