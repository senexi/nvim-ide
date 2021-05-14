#!/bin/bash
ARCH=${1:-"amd64"}
ARCH2=${2:-"x86_64"}

TARGET="devops-ide"
BUILDER="docker"

if ! command -v $BUILDER &> /dev/null
then
    BUILDER="podman"
fi


if [ $ARCH = "arm64v8" ]
then
  ARCH2="aarch64"
fi

echo "using arch $ARCH $ARCH2"
$BUILDER build --build-arg ARCH=$ARCH --build-arg ARCH2=$ARCH2  -t $TARGET:latest -f ./Containerfile .
