#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Helper script to symlink ~/.gemini/skills and ~/.claude/skills directory
## to ~/.agents/skills
set -eo

declare CENTRAL_SKILL_DIR="$HOME/.agents/skills"
declare AGENTS_HOME_DIR=(
    #"$HOME/.gemini" -- Gemini recognizes ~/.agents/skills without the symlink
    "$HOME/.claude"
)

main () {
    if [ ! -d "$CENTRAL_SKILL_DIR" ]; then
        log_fatal "$CENTRAL_SKILL_DIR does not exist"
    fi

    for home_dir in "${AGENTS_HOME_DIR[@]}"; do
        local agent_skill_dir="$home_dir/skills"
        if [ -d "$agent_skill_dir" ]; then
            log_err "$agent_skill_dir exists. Override? (press Enter to continue)"
            read -r
            rm -rf "$agent_skill_dir"
        fi
        log_info "Symlinking $CENTRAL_SKILL_DIR to $agent_skill_dir. Continue? (press Enter)"
        read -r
        ln -sf "$CENTRAL_SKILL_DIR" "$agent_skill_dir"
    done
}


log_info() {
    echo "[+] $*"
}

log_err() {
    echo "[!] $*"
}

log_fatal() {
    echo "[!!] $*"
    exit 1
}

### Execute main ###
main
