#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
wget https://github.com/neovide/neovide/releases/latest/download/neovide.tar.gz  -O /tmp/neovide.tar.gz
tar xvf /tmp/neovide.tar.gz --directory $HOME/.local/bin
chmod u+x $HOME/.local/bin/neovide 

