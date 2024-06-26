#!/usr/bin/env bash
# Initial setup for Fedora
ENVIRONMENT=$HOME/.dot/.config/cconf/environments

pushd $HOME/.dot
set -x
git submodule update --init
$ENVIRONMENT/fedora/dnf-speed-up.sh
$ENVIRONMENT/fedora/dnf-install-base-requirements.sh
$ENVIRONMENT/fedora/fedora-enable-rpm-fusion.sh
$ENVIRONMENT/fedora/fedora-install-media-codecs.sh
$ENVIRONMENT/flatpak-install-apps.sh
$ENVIRONMENT/starship-install.sh
popd
nvim
