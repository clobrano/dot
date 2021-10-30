#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

set -x
git config --global user.name "Carlo Lobrano"
git config --global user.email c.lobrano@gmail.com
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor nvim
git config --global merge.conflictStyle diff3 # include common ancestor
git config --global init.defaultBranch main

git config --global alias.co checkout
git config --global alias.cm commit
git config --global alias.sw switch
git config --global alias.st status
git config --global alias.sh stash

git config pull.rebase false
