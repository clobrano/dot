#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -u

fonts=(
    #"https://github.com/microsoft/cascadia-code/releases/download/v1911.21/CascadiaMono.ttf"
    #"https://github.com/hbin/top-programming-fonts/raw/master/Monaco-Linux.ttf"
    #"https://raw.githubusercontent.com/adobe-fonts/source-code-pro/release/TTF/SourceCodePro-Regular.ttf"
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SourceCodePro.zip"
    "https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip"
    "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"
)


mkdir -pv "$HOME/.local/share/fonts"
new_font=0
for font in "${fonts[@]}"; do
    filename=$(basename "$font")
    if [[ ${filename} =~ ".zip" ]]; then
        echo "[+] installing ${font}..."
        tmpdir=$(mktemp -d)
        wget -O "${tmpdir}/${filename}" "$font"
        ls -l "${tmpdir}"
        unzip -o "${tmpdir}/${filename}" -d "$HOME/.local/share/fonts/"
        new_font=1
        continue
    fi

    dst=$HOME/.local/share/fonts/$filename
    if [ ! -f "$dst" ]; then
        echo "[+] installing $filename from $font ..."
        wget -O "$dst" "$font"
        new_font=1
    fi
done

[ $new_font == 1 ] && fc-cache -vf
