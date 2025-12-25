#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -x

mkdir -p ~/.local/bin
curl -sL -o ~/.local/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/.local/bin/gimme
