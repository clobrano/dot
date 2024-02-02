#!/usr/bin/env bash
# Initial setup for Fedora
ENVIRONMENT=$HOME/.dot/.config/cconf/environments

pushd $HOME/.dot
set -x
git submodule update --init
$ENVIRONMENT/dnf-speed-up.sh
$ENVIRONMENT/dnf-install-base-requirements.sh
$ENVIRONMENT/fedora-enable-rpm-fusion.sh
$ENVIRONMENT/fedora-install-media-codecs.sh
$ENVIRONMENT/flatpak-install-apps.sh

$HOME/.dot/link.sh
popd
nvim
