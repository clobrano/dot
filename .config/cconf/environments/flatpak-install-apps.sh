#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -x

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#flatpak install flathub com.nextcloud.desktopclient.nextcloud

selection=(
    com.dropbox.Client
    com.github.tchx84.Flatseal
    com.google.Chrome
    com.raggesilver.BlackBox
    md.obsidian.Obsidian
    org.gnome.gitlab.somas.Apostrophe 
    org.telegram.desktop
)


for package in ${selection[@]}; do
    flatpak install --assumeyes ${package}
done
