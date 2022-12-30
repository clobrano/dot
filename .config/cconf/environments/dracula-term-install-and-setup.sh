#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#sudo apt-get install dconf-cli

if command -v gnome-terminal; then
    git clone https://github.com/dracula/gnome-terminal ~/workspace/toolkit/dracula-gnome-terminal
    pushd ~/workspace/toolkit/dracula-gnome-terminal
    ./install.sh
    popd
fi

if command -v konsole; then
    wget https://github.com/dracula/konsole/archive/master.zip
    unzip master.zip
    cp konsole-master/Dracula.colorscheme ~/.local/share/konsole/
    cat <<EOF
    Now go to Konsole > Settings > Edit Current Profile… > Appearance tab
    Select the Dracula scheme from the Color Schemes & Background… pane
EOF
    rm -r konsole-master master.zip
fi
