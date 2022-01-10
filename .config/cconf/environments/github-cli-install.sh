#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

if [[ $(which apt | wc -l) = "1" ]]; then
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    sudo apt-add-repository https://cli.github.com/packages
    sudo apt update
    sudo apt install gh
fi

if [[ $(which dnf | wc -l) = "1" ]]; then
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install gh
fi
