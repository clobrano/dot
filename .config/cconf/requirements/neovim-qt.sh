#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -xeu
git clone https://github.com/equalsraf/neovim-qt.git
sudo apt install -y qt5-default

cd neovim-qt
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install


