#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Read current Letsdo task title from tmux

shopt -s extglob  # bash only

# No Letsdo configuration
[ ! -f $HOME/.letsdo ] && exit 0


DATA_DIRECTORY=$(sed -n 's/DATA_DIRECTORY:\s*\(.*\)/\1/p' "$HOME/.letsdo")

# no running tasks
if [ ! -f  "$DATA_DIRECTORY/letsdo-task" ]; then
    echo ""
    dconf write /org/gnome/shell/extensions/one-thing/thing-value "''"
    exit 0
fi

name=$(sed -n 's_"name": "\(.*\)",_\1_p' "$DATA_DIRECTORY/letsdo-task")
name=${name##+([[:space:]])}    # strip leading whitespace;  no quote expansion!
name=${name%%+([[:space:]])}   # strip trailing whitespace; no quote expansion!

begin=$(date +%s -d "$(sed -n 's_"start": "\(.*\)"_\1_p' "$DATA_DIRECTORY/letsdo-task")")

task_len=${#name}
if [[ $task_len > 40 ]]; then
    name=${name:0:27}...
fi
end=$(date +%s)

dconf write /org/gnome/shell/extensions/one-thing/thing-value "'$name $(date +"%kh:%Mm" --date="@$(($end - $begin - 3600))")'"
# Why I need an 1h offset to get the right value? Is it for the daylight setting?
echo "󰔛 $name$(date +"%kh:%Mm" --date="@$(($end - $begin - 3600))")"

