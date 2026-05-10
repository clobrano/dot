#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -xeu
[ ! -d  neovim-qt ] && git clone https://github.com/equalsraf/neovim-qt.git

sudo apt install -y libqt5svg5-dev qt5-default cmake

pushd neovim-qt
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
cd -
popd
rm -rv neovim-qt

