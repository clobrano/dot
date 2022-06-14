#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# install using the "convenience script"
curl -fsSL https://get.docker.com -o get-docker.sh
chmod u+x ./get-docker.sh
./get-docker.sh
sudo systemctl enable docker
sudo usermod -G docker -a $USER
sudo systemctl restart docker
docker version
docker run --rm hello-world

