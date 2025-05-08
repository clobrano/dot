#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
function zsh_kube_prompt() {
    # Keep the space at the end of the printf message
    current_context=$(oc config current-context | cut -d'/' -f1)
    cluster_name=$(yq ".contexts.[] | select(.name == \"${current_context}\").context.cluster" ~/.kube/config)
    server=$(yq ".clusters.[] | select(.name == \"${cluster_name}\").cluster.server" ~/.kube/config)
    server=$(echo "$server" | sed 's/https:\/\///' | sed 's/:6443//')
    if [[ "$server" =~ "aws" ]]; then
        server="aws"
    fi
    [ -n "$cluster_name" ] && [ -n "$server" ] && printf "󱃾  %s/%s" "$cluster_name" "$server"
}
zsh_kube_prompt
