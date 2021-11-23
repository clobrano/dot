#!/usr/bin/env bash

has_apt=$(which apt | wc -l)
if [[ $has_apt == "1" ]]; then
	sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl
fi


has_yum=$(which yum | wc -l)
if [[ $has_yum == "1" ]]; then
	sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl
fi


if [[ $has_yum == "0" ]] && [[ $has_apt == "0" ]]; then
	echo "[!] Unsupported system (not apt, nor yum based)"
	exit 1
fi

set -x
git clone https://github.com/neovim/neovim
pushd neovim
git checkout stable
make -j$(nproc)
sudo make install
popd
sudo rm -r neovim

# Needed for telescope live_grep/grep_string
sudo apt install ripgrep
