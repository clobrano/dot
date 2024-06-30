#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

windows=$(hyprctl -j clients)
active_address=$(hyprctl -j activewindow | jq -r '.address')

selected=$(echo $windows | \
    jq -r '.[] | "\(.initialTitle) |\(.address)"' | \
    sed "s|$active_address|focused|" | \
    rofi -dmenu -p "" -i -normal-window)

set -x
addr="$(echo "$selected" | awk -F '|' '{print $2}')"

hyprctl dispatch focuswindow address:$addr

