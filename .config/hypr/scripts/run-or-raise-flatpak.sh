#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

is_running=$(hyprctl clients | grep -c $1)
if [[ $is_running -eq 0 ]]; then
    flatpak run $2
else
    hyprctl dispatch focuswindow $1
fi
