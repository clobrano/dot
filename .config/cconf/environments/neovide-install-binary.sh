#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
VERSION=$(curl --silent "https://api.github.com/repos/neovide/neovide/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
echo "Installing neovide version $VERSION"

wget https://github.com/neovide/neovide/releases/download/${VERSION}/neovide-linux-x86_64.tar.gz  -O /tmp/neovide.tar.gz
tar xvf /tmp/neovide.tar.gz --directory $HOME/.local/bin
chmod u+x $HOME/.local/bin/neovide 

