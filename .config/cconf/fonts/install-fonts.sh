#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

git clone https://github.com/powerline/fonts.git --depth=1 $HOME/.powerline-fonts
./$HOME/.powerline-fonts/install.sh
fc-cache -vf
