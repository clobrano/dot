#!/usr/bin/env bash
# Install all the package in the provided input file.
# The input file shall contain one package per line.

[ ! -f "$1" ] && echo "$1 is not a valid file" && exit 1

set -eu
FILEPATH=$1

for d in $(awk '/^\s*[^#]/' "$FILEPATH"); do
    if [ 0 == $(dpkg -l | grep $d | wc -l) ]; then
        echo installing $d...
        sudo apt-get install -y $d
    fi
done
