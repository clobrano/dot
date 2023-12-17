#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Read current Letsdo task title from tmux

shopt -s extglob  # bash only

# No Letsdo configuration
[ ! -f $HOME/.letsdo ] && exit 0

DATA_DIRECTORY=$(sed -n 's/DATA_DIRECTORY:\s*\(.*\)/\1/p' "$HOME/.letsdo")

# no running tasks
if [ ! -f  "$DATA_DIRECTORY/letsdo-task" ]; then
    echo "No task running"
    dconf write /org/gnome/shell/extensions/one-thing/thing-value "''"
    exit 0
fi

task=$(sed -n 's_"name": "\(.*\)",_\1_p' "$DATA_DIRECTORY/letsdo-task")
task=${task##+([[:space:]])}    # strip leading whitespace;  no quote expansion!
task=${task%%+([[:space:]])}   # strip trailing whitespace; no quote expansion!

task_len=${#task}
if [[ $task_len > 40 ]]; then
    task=${task:0:27}...
fi
begin=$(date +%s -d "$(sed -n 's_"start": "\(.*\)"_\1_p' "$DATA_DIRECTORY/letsdo-task")")
end=$(date +%s)

dconf write /org/gnome/shell/extensions/one-thing/thing-value "'$task$(date +"%kh:%Mm" --date="@$(($end - $begin - 3600))")'"
# Why I need an 1h offset to get the right value? Is it for the daylight setting?
echo "$task$(date +"%kh:%Mm" --date="@$(($end - $begin - 3600))") 🕓"

