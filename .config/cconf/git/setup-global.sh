#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

set -x
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor nvim
git config --global merge.conflictStyle diff3 # include common ancestor
git config --global init.defaultBranch main
git config --global pull.rebase false

git config --global alias.co checkout
git config --global alias.cm commit
git config --global alias.sw switch
git config --global alias.st status
git config --global alias.sh stash
git config --global alias.pl pull
git config --global alias.l "log --graph --oneline -n"

git config pull.rebase false
