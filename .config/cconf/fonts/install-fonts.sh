#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -e

#git clone https://github.com/powerline/fonts.git --depth=1 $HOME/.powerline-fonts
#./$HOME/.powerline-fonts/install.sh
#rm -r $HOME/.powerline-fonts

wget $HOME/.local/share/fonts https://github.com/hbin/top-programming-fonts/raw/master/Monaco-Linux.ttf

fc-cache -vf
