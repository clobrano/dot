#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

if command -v apt >/dev/null; then
    installer="apt"
fi
if command -v zypper >/dev/null; then
    installer="zypper"
fi

set -xe
sudo $installer install docker
sudo systemctl enable docker
sudo usermod -G docker -a $USER
sudo systemctl restart docker
docker version
docker run --rm hello-world
