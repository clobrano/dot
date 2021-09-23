#!/usr/bin/env bash
# Install all the package in the provided input file.
# The input file shall contain one package per line.

set -u
distro=`cat /etc/os-release | grep -E "^NAME" | cut -d'=' -f2`

[ ! -f "$1" ] && echo "$1 is not a valid file" && exit 1

FILEPATH=$1

if [[ "$distro" == "\"Ubuntu\"" ]] || [[ "$distro" == "\"elementary OS\"" ]]; then
    installer=apt-get
else if [[ "$distro" == "Fedora" ]]; then
        installer=dnf
    else
        echo [!] $distro distribution is not supported yet.
        exit 1
    fi
fi 

for d in $(awk '/^\s*[^#]/' "$FILEPATH"); do
    echo installing $d...
    sudo "$installer" install -y $d
done
