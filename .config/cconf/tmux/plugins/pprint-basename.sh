#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# Abbreviate project names intelligently
abbreviate() {
    local name=$1

    # CamelCase: ClusterLabs → cl
    if [[ $name =~ [A-Z] ]]; then
        echo "$name" | sed 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]'
        return
    fi

    # Hyphenated: fence-agents-remediation → far
    if [[ $name == *-* ]]; then
        echo "$name" | awk -F'-' '{for(i=1;i<=NF;i++) printf substr($i,1,1)}' | tr '[:upper:]' '[:lower:]'
        return
    fi

    # Underscored: node_health_check → nhc
    if [[ $name == *_* ]]; then
        echo "$name" | awk -F'_' '{for(i=1;i<=NF;i++) printf substr($i,1,1)}' | tr '[:upper:]' '[:lower:]'
        return
    fi

    # Simple name: keep as is
    echo "$name"
}

PWD=$1
if [[ ${PWD} == "${HOME}" ]]; then
    echo "~"
    exit 0
fi

# Check if we're in a git worktree
if git -C "${PWD}" rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the worktree root directory
    worktree_root=$(git -C "${PWD}" rev-parse --show-toplevel)

    # Split path into components
    IFS='/' read -ra parts <<< "${worktree_root}"
    len=${#parts[@]}

    # For git worktrees with format: workspace/org/project/branch-type/branch-name
    # Show: project/branch-type/branch-name (last 3 components)
    if [[ $len -ge 3 ]]; then
        project=$(abbreviate "${parts[$len-3]}")
        echo "${project}/${parts[$len-2]}/${parts[$len-1]}"
    elif [[ $len -eq 2 ]]; then
        project=$(abbreviate "${parts[$len-2]}")
        echo "${project}/${parts[$len-1]}"
    else
        echo "${parts[$len-1]}"
    fi
else
    # Non-git paths: show parent/current as before
    parent=$(dirname "${PWD}")
    current=$(basename "${PWD}")
    if [[ $parent != "${HOME}" ]]; then
        echo "$(basename "$parent")/$current"
    else
        echo "$current"
    fi
fi
