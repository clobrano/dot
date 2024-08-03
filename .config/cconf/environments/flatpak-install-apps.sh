#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -x

if !command -v flatpak 2>/dev/null; then
    sudo dnf install -y flatpak
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#flatpak install flathub com.nextcloud.desktopclient.nextcloud

selection=(
    com.dropbox.Client
    com.github.tchx84.Flatseal
    com.google.Chrome
    com.raggesilver.BlackBox
    md.obsidian.Obsidian
    org.telegram.desktop
    me.kozec.synchthingtk
)


for package in ${selection[@]}; do
    flatpak install --assumeyes ${package}
done
