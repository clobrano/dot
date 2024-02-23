#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -e

if [[ ! -f  /etc/dnf/dnf.conf.bk ]]; then
    echo [+] backing up dnf.conf
    sudo cp /etc/dnf/dnf.conf{,.bk}

    if [[ ! -f  /etc/dnf/dnf.conf.bk ]]; then
        echo [!] could not backup dnf.conf
        exit 1
    fi
fi

if ! grep "max_parallel_downloads=10" /etc/dnf/dnf.conf; then
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
fi
if ! grep "fastestmirror=True" /etc/dnf/dnf.conf; then
    echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
fi
