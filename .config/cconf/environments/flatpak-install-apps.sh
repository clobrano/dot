#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -x

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.nextcloud.desktopclient.nextcloud
flatpak install flathub md.obsidian.Obsidian
