#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# This script is a container for utilities that needs to be run
# at a given interval.

# GH unread notifications
#interval_time_min=15
#current_time_min=$(date +%M)
#if [ $((current_time_min % interval_time_min)) -eq 0 ]; then
    #"$HOME/workspace/script-fu/gh-pr-notifier.sh"
#fi


## ccusage stats view
ccusage_bin="$HOME/.npm-global/bin/ccusage"
ccusage_slot_file="$HOME/.ccusage-last-slot"
ccusage_lock_file="$HOME/.ccusage.lock"
# The tmux status line invokes this script every 10 seconds.
current_slot=$(($(date +%s) / 600))

update_ccusage() {
    local monthly_json daily_json monthly_view daily_view monthly_view_int monthly_budget percentage tmpfile

    if ! monthly_json=$("$ccusage_bin" monthly --last 1 --json) ||
       ! daily_json=$("$ccusage_bin" daily --last 1 --json) ||
       ! monthly_view=$(jq -er '(.totals.totalCost | . * 100 | round / 100)' <<< "$monthly_json") ||
       ! daily_view=$(jq -er '(.totals.totalCost | . * 100 | round / 100)' <<< "$daily_json"); then
        return 1
    fi

    monthly_view_int=${monthly_view%%.*}
    monthly_budget=300
    percentage=$((monthly_view_int * 100 / monthly_budget))
    tmpfile=$(mktemp "$HOME/.ccusage.txt.XXXXXX") || return 1
    if printf '$%s $%s %%%s\n' "$daily_view" "$monthly_view" "$percentage" > "$tmpfile" &&
       mv -f -- "$tmpfile" "$HOME/.ccusage.txt"; then
        return 0
    fi
    rm -f -- "$tmpfile"
    return 1
}

last_slot=
if [[ -r "$ccusage_slot_file" ]]; then
    read -r last_slot < "$ccusage_slot_file"
fi

if [[ "$current_slot" != "$last_slot" ]]; then
    exec 9>"$ccusage_lock_file"
    if flock -n 9; then
        last_slot=
        if [[ -r "$ccusage_slot_file" ]]; then
            read -r last_slot < "$ccusage_slot_file"
        fi
        if [[ "$current_slot" != "$last_slot" ]]; then
            update_ccusage
            # Record attempts too, so failures do not retry on every redraw.
            printf '%s\n' "$current_slot" > "$ccusage_slot_file"
        fi
    fi
fi
