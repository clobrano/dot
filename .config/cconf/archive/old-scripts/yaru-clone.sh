#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

DST=~/workspace/ubuntu
mkdir -p ${DST}
if [ ! -d ${DST}/yaru ]; then
    git clone git@github.com:ubuntu/yaru.git ${DST}/yaru || git clone https://github.com/ubuntu/yaru.git ${DST}/yaru
fi

