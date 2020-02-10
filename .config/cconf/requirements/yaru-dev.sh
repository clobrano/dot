#!/usr/bin/env bash
# -*- coding: UTF-8 -*-


mkdir -p ~/workspace
if [ ! -d ~/workspace/yaru ]; then
    git clone git@github.com:ubuntu/yaru.git ~/workspace/yaru || git clone https://github.com/ubuntu/yaru.git ~/workspace/yaru
fi

sudo apt install libgtk-3-dev git meson sassc gtk-3-examples gnome-tweaks
