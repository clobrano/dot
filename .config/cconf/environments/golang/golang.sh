#!/usr/bin/env bash
# Install golang runtime
: ${INSTALL_GO_VERSION:="1.20.12"}
URL=https://go.dev/dl/go${INSTALL_GO_VERSION}.linux-amd64.tar.gz

echo "Install version INSTALL_GO_VERSION=${INSTALL_GO_VERSION}?"
read

# Get the tarball
wget --tries=3 --no-clobber $URL

# Remove already installed go
sudo rm -rf /usr/local/go

# Copy new version
sudo tar -C /usr/local -xzf go${INSTALL_GO_VERSION}.linux-amd64.tar.gz
/usr/local/go/bin/go version

# Clean the environment
[[ $? == 0 ]] && rm go${INSTALL_GO_VERSION}.linux-amd64.tar.gz
