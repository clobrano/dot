#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

set -ex

version=3.0.13
package=exercism-$version-linux-x86_64.tar.gz

echo [+] getting Exercism $version CLI
wget https://github.com/exercism/cli/releases/download/v$version/$package
tar -xf $package
mkdir -p ~/.local/bin
chmod +x exercism
mv exercism ~/.local/bin
rm $package
