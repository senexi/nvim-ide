#!/bin/bash
ARCH=${1:-"amd64"}
REPO=${2:-"senexi"}

TARGET="vim-ide"
BUILDER="docker"

if ! command -v $BUILDER &> /dev/null
then
    BUILDER="podman"
fi
echo "using arch $ARCH"
IMAGE=$TARGET:$ARCH-latest

$BUILDER push $IMAGE $REPO/$IMAGE
