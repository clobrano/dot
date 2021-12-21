#!/usr/bin/env bash

has_apt=$(which apt 2>/dev/null | wc -l)
if [[ $has_apt == "1" ]]; then
    sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl
fi


has_yum=$(which yum 2>/dev/null | wc -l)
if [[ $has_yum == "1" ]]; then
    sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl
fi

has_zypper=$(which zypper 2>/dev/null | wc -l)
if [[ $has_yum == "1" ]]; then
    sudo zypper -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl
fi


if [[ $has_yum == "0" ]] && [[ $has_apt == "0" ]]; then
	echo "[!] Unsupported system (not apt, nor yum based)"
	exit 1
fi

NVIMDIR=${HOME}/workspace/neovim
[[ ! -d ${HOME}/workspace ]] && mkdir -pv ${HOME}/workspace

if [[ ! -d ${NVIMDIR} ]]; then
	git clone https://github.com/neovim/neovim ${NVIMDIR}
fi
pushd ${NVIMDIR}
git pull
git checkout stable
make -j$(nproc)
sudo make install
popd

# Needed for telescope live_grep/grep_string
sudo apt install ripgrep
