#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
INSTALL_DIR=$HOME/workspace/neovide

if ! which cargo 2>/dev/null;
then
    echo [!] rust seems not installed!
    exit 1
fi

if command -v apt 2>/dev/null; then
    sudo apt install -y curl \
        gnupg ca-certificates git \
        gcc-multilib g++-multilib cmake libssl-dev pkg-config \
        libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
        libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev
else if command -v dnf 2>/dev/null; then
    sudo dnf install -y fontconfig-devel freetype-devel libX11-xcb libX11-devel libstdc++-static libstdc++-devel
    sudo dnf groupinstall "Development Tools" "Development Libraries"
else
    echo "[!] installer not supported (not fedora nor ubuntu)"
    exit 1
fi
fi

if [[ ! -d $INSTALL_DIR ]]; then
    git clone "https://github.com/neovide/neovide" $INSTALL_DIR
fi

curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh

cargo install --git https://github.com/neovide/neovide

#pushd $INSTALL_DIR
#~/.cargo/bin/cargo build --release
#popd
