#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
function zsh_kube_prompt() {
    # Keep the space at the end of the printf message
    printf "$(basename `readlink $HOME/.kube/config` | awk -F"." '{print $1"."$2}') "
}

zsh_kube_prompt
