#!/usr/bin/env bash
# Install golang runtime
VERSION=1.20.12
URL=https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz

set -e

# Get the tarball
wget --tries=3 --no-clobber $URL

# Remove already installed go
sudo rm -rf /usr/local/go

# Copy new version
sudo tar -C /usr/local -xzf go${VERSION}.linux-amd64.tar.gz
/usr/local/go/bin/go version

# Clean the environment
[[ $? == 0 ]] && rm go${VERSION}.linux-amd64.tar.gz

# Install gimme
# assumes ~/bin exists and is in $PATH, so adjust accordingly!
mkdir -p ~/.local/bin
curl -sL -o ~/.local/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/.local/bin/gimme
