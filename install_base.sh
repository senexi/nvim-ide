#!/bin/bash

echo "install apt packages"
DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -qq install --no-install-recommends  vim \
    build-essential \
	silversearcher-ag \
	postgresql-client \
	less \
    mpv \
    ssh \
	zsh \
    git \
    gnupg \
    make \
    wget \
    gcc \
    exuberant-ctags \
    curl \
    neovim \
    zip \
    unzip \
    jq \
    iputils-ping \
    netcat \
    nmap \
    python3-pip \
    python3-venv \
    apt-transport-https \
    jsonnet
