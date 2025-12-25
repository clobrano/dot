#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

git clone https://github.com/flutter/flutter.git -b stable $HOME/workspace/flutter

if [[ `grep flutter $HOME/.local_bashrc | wc -l` = "0" ]]; then
    echo export PATH="`$PATH`:$HOME/workspace/flutter/bin" >> $HOME/.local_bashrc
fi

$HOME/workspace/flutter doctor
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
flutter config --enable-linux-desktop
