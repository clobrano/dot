#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
pushd ~
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
popd
