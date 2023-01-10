#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
function zsh_kube_prompt() {
    if ! command -v kubectl 2>&1 >/dev/null; then
        return
    fi
    context=$(kubectl config current-context 2>/dev/null)
    if [[ -z $context ]]; then
        return
    fi
    cluster="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.cluster}")"
    if [[ -n $cluster ]]; then
        printf "kluster:%s " ${cluster}
    else
        printf ""
    fi
}

zsh_kube_prompt
