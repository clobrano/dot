#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
if [[ ! -f ~/.config/nvim/autoload/plug.vim ]]; then
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo [+] install neovim plugins [ENTER/CTRL-C]?
read
nvim +PlugInstall
