#!/usr/bin/env bash
# Initial setup for Fedora
ENVIRONMENT=~/.dot/.config/cconf/environments

set -x
git submodule update --init
$ENVIRONMENT/dnf-speed-up.sh
$ENVIRONMENT/dnf-install-base-requirements.sh
$ENVIRONMENT/fedora-enable-rpm-fusion.sh
$ENVIRONMENT/flatpak-install-apps.sh

./link.sh
$ENVIRONMENT/vim-plug-install.sh
nvim
