#!/bin/bash
ARCH=${1:-"amd64"}
REPO=${2:-"senexi"}

TARGET="go-ide"
BUILDER="docker"

if ! command -v $BUILDER &> /dev/null
then
    BUILDER="podman"
fi
echo "using arch $ARCH"
$BUILDER push $REPO/$TARGET:$ARCH-latest
