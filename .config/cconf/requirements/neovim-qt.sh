#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -xeu
[ ! -d  neovim-qt ] && git clone https://github.com/equalsraf/neovim-qt.git

sudo apt install -y libqt5svg5-dev qt5-default cmake

cd neovim-qt
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
cd -
rm -rv neovim-qt

