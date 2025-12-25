#!/usr/bin/env bash
# Initial setup for Fedora
ENVIRONMENT=$HOME/.dot/.config/cconf/environments

pushd $HOME/.dot
set -x
git submodule update --init
$ENVIRONMENT/fedora/01-fedora-dnf-speed-up.sh
$ENVIRONMENT/fedora/02-dnf-install-base-requirements.sh
$ENVIRONMENT/fedora/03-fedora-enable-rpm-fusion.sh
$ENVIRONMENT/fedora/04-fedora-install-media-codecs.sh
$ENVIRONMENT/flatpak-install-apps.sh
$ENVIRONMENT/starship-install.sh
popd
nvim
