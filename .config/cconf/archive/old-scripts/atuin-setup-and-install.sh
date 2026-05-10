#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
atuin login -u clobrano
atuin import bash
atuin import zsh
