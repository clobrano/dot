#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## 2024-09-02: required for wayland
set -e
ESPANSO_VERSION="v2.2.1"

sudo dnf install -y @development-tools gcc-c++ wl-clipboard libxkbcommon-devel dbus-devel wxGTK-devel.x86_64
cargo install --force cargo-make --version 0.34.0

# Clone the Espanso repository
if [[ ! -d ~/Apps/espanso ]]; then
    git clone https://github.com/espanso/espanso ~/Apps/espanso
fi
cd ~/Apps/espanso
git checkout $ESPANSO_VERSION
# Compile espanso in release mode
# NOTE: this will take a while (~5/15 minutes)
cargo make --profile release --env NO_X11=true build-binary

mkdir -p ~/.local/bin
cp target/release/espanso ~/.local/bin

