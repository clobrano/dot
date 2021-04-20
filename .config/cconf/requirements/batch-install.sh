#!/usr/bin/env bash
# Install all the package in the provided input file.
# The input file shall contain one package per line.

set -eu
distro=`cat /etc/os-release | grep -E "^NAME" | cut -d'=' -f2`

[ ! -f "$1" ] && echo "$1 is not a valid file" && exit 1

FILEPATH=$1

if [[ "$distro" == "Ubuntu" ]]; then
    for d in $(awk '/^\s*[^#]/' "$FILEPATH"); do
        if [ 0 == $(dpkg -l | grep $d | wc -l) ]; then
            echo installing $d...
            sudo apt-get install -y $d
        fi
    done
else
    echo [!] $distro distribution is not supported yet.
fi
