#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
wget https://github.com/smallhadroncollider/taskell/releases/download/1.7.2/taskell-1.7.2_x86-64-linux.deb
sudo dpkg -i taskell-1.7.2_x86-64-linux.deb
rm taskell-1.7.2_x86-64-linux.deb
sudo apt install libtinfo5
