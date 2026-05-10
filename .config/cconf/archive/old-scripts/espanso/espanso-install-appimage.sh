#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# Create the $HOME/Apps destination folder
mkdir -p ~/Apps
# Download the AppImage inside it
wget -O ~/Apps/Espanso.AppImage 'https://github.com/espanso/espanso/releases/download/v2.2.1/Espanso-X11.AppImage'
# Make it executable
chmod u+x ~/Apps/Espanso.AppImage
# Create the "espanso" command alias
sudo ~/Apps/Espanso.AppImage env-path register
