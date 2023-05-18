#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

if [[ ! -d  $HOME/.config/ranger/plugins/ranger_devicons ]]; then
    mkdir -pv ~/.config/ranger/plugins
    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
fi

if [ $(grep -ce "default_linemode devicons "$HOME/.config/ranger/rc.conf) -eq 0 ]; then
    echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
fi
