#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

windows=$(hyprctl -j clients)
active_address=$(hyprctl -j activewindow | jq -r '.address')

selected=$(echo $windows | \
    jq -r '.[] | "\(.initialTitle) (\(.title)) |\(.address)"' | \
    sed "s|$active_address|focused|" | \
    rofi -dmenu -p "Windows:" -i -normal-window)

addr="$(echo "$selected" | awk -F '|' '{print $2}')"

hyprctl dispatch focuswindow address:$addr

