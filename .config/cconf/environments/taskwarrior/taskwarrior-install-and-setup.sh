#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

echo "installing tasklib..."
pip3 install --user tasklib
pip3 install --user pynvim

echo "installing letsdo..."
pip3 install --user letsdo

set -x
if [ ! -f task-3.3.0.tar.gz ]; then
    if ! wget https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.3.0/task-3.3.0.tar.gz; then
        echo "[!] could not curl taskwarrior"
        exit 1
    fi
fi

sudo dnf install -y cmake libuuid-devel
../rust-install-and-setup.sh

mkdir -p ~/Apps
mv task-3.3.0.tar.gz ~/Apps

pushd ~/Apps || exit 1
tar xvf task-3.3.0.tar.gz
cd task-3.3.0
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build
popd || exit 1

echo [+] done.
