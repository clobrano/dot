#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -e

#git clone https://github.com/powerline/fonts.git --depth=1 $HOME/.powerline-fonts
#./$HOME/.powerline-fonts/install.sh
#rm -r $HOME/.powerline-fonts

if [ ! -f $HOME/.local/share/fonts/Monaco-Linux.ttf ]; then
    wget -O $HOME/.local/share/fonts/Monaco-Linux.ttf https://github.com/hbin/top-programming-fonts/raw/master/Monaco-Linux.ttf

    fc-cache -vf
fi
