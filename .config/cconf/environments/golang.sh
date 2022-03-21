#!/usr/bin/env bash
# Install golang runtime
VERSION=1.17.7
URL=https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz
wget --tries=3 --no-clobber $URL
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${VERSION}.linux-amd64.tar.gz
[[ $? == 0 ]] && rm go${VERSION}.linux-amd64.tar.gz
/usr/local/go/bin/go version
