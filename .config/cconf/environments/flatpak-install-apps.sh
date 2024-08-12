#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -x

if !command -v flatpak 2>/dev/null; then
    sudo dnf install -y flatpak
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

selection=(
    com.github.tchx84.Flatseal
    org.wezfurlong.wezterm
    com.google.Chrome
    com.dropbox.Client
    me.kozec.syncthingtk
    md.obsidian.Obsidian
    org.telegram.desktop
    com.slack.Slack
)


for package in ${selection[@]}; do
    flatpak install --assumeyes ${package}
done
