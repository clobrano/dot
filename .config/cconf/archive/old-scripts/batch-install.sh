#!/usr/bin/env bash
# Install all the package in the provided input file.
# The input file shall contain one package per line.

distro=`cat /etc/os-release | grep -E "^NAME" | cut -d'=' -f2`

[ ! -f "$1" ] && echo "$1 is not a valid file" && exit 1

FILEPATH=$1

if [[ "$distro" == "\"Ubuntu\"" ]] || [[ "$distro" == "\"elementary OS\"" ]]; then
    installer=apt-get
fi
if [[ "$distro" == "Fedora" ]]; then
        installer=dnf
fi
if [[ "$distro" =~ "openSUSE" ]]; then
        installer=zypper
fi

if [[ -z $installer ]]; then
    echo [!] $distro distribution is not supported yet.
    exit 1
fi

for d in $(awk '/^\s*[^#]/' "$FILEPATH"); do
    echo installing $d...
    sudo "$installer" install -y $d
done
