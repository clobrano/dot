#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -u

fonts=(
    "https://github.com/microsoft/cascadia-code/releases/download/v1911.21/CascadiaMono.ttf"
    "https://github.com/hbin/top-programming-fonts/raw/master/Monaco-Linux.ttf"
    "https://raw.githubusercontent.com/adobe-fonts/source-code-pro/release/TTF/SourceCodePro-Regular.ttf"
)

mkdir -pv $HOME/.local/share/fonts
new_font=0
for font in ${fonts[@]}; do
    filename=$(basename $font)
    dst=$HOME/.local/share/fonts/$filename
    if [ ! -f $dst ]; then
        echo installing $filename from $font
        wget -O $dst $font
        new_font=1
    fi
done

[ $new_font == 1 ] && fc-cache -vf

exit 0
