#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
INSTALL_DIR=$HOME/workspace/neovide

if ! which cargo 2>/dev/null;
then
    echo [!] rust seems not installed!
    exit 1
fi

sudo apt install -y curl \
    gnupg ca-certificates git \
    gcc-multilib g++-multilib cmake libssl-dev pkg-config \
    libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
    libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev

if [[ ! -f $INSTALL_DIR ]]; then
    git clone "https://github.com/neovide/neovide" $INSTALL_DIR
fi

pushd $INSTALL_DIR
~/.cargo/bin/cargo build --release
popd
