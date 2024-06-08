#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

is_running=$(hyprctl clients | grep -c "title: Neovim")
if [[ $is_running -eq 0 ]]; then
    alacritty --title Neovim --working-directory ~/Dropbox/notes -e nvim
else
    hyprctl dispatch focuswindow title:Neovim
fi
