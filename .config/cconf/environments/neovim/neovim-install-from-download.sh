#!/usr/bin/env bash
set-x
VERSION=v0.11.4
FILENAME="nvim-linux-x86_64.tar.gz"
FORCE=1
URL="https://github.com/neovim/neovim/releases/download/$VERSION/$FILENAME"

if [ ! -f $FILENAME ] || [ "$FORCE" -eq 1 ]; then
	wget "$URL"
fi

sudo tar xvzf ./nvim-linux-x86_64.tar.gz -C /opt/
