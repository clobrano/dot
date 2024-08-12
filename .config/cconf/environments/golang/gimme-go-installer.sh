#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -x
# assumes ~/bin exists and is in $PATH, so adjust accordingly!

curl -sL -o ~/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/bin/gimme
