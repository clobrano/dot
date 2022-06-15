#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

if !which apt 2>/dev/null; then
    echo [!] only supporting apt installer.
    exit 1
fi

deps=(wget curl gnupg2)
for d in ${deps[@]}; do
    if !which ${d} 2>/dev/null; then
        sudo apt install -y ${d}
    fi
done

source /etc/os-release
set -x
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O- | sudo apt-key add -

sudo apt-get update -qq -y
sudo apt-get -qq --yes install podman

podman --version
