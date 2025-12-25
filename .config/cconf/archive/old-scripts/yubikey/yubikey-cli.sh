#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

sudo dnf -y install \
    python3-devel \
    pcsc-live-devel \
    yubikey-personalization-gui
pip install yubikey-manager

## usage
## ykman oauth accounts code <account name>
