#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
VERSION=0.8.1

wget --no-clobber \
    --continue \
    --progress=bar \
    https://github.com/muesli/duf/releases/download/v${VERSION}/duf_${VERSION}_linux_amd64.deb

sudo apt install ./duf_${VERSION}_linux_amd64.deb
rm duf_${VERSION}_linux_amd64.deb
