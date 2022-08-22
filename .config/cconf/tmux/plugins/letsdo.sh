#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Read current Letsdo task title from tmux

# No Letsdo configuration
[ ! -f $HOME/.letsdo ] && exit 0

DATA_DIRECTORY=$(sed -n 's/DATA_DIRECTORY:\s*\(.*\)/\1/p' "$HOME/.letsdo")

# no running tasks
[ ! -f  "$DATA_DIRECTORY/letsdo-task" ] && exit 0

task=$(sed -n 's_"name": "\(.*\)",_\1_p' "$DATA_DIRECTORY/letsdo-task")
task_len=${#task}
if [[ $task_len > 30 ]]; then
    task=${task:0:27}...
else
    # preserve the space after task name.
    task="${task} "
fi
begin=$(date +%s -d "$(sed -n 's_"start": "\(.*\)"_\1_p' "$DATA_DIRECTORY/letsdo-task")")
end=$(date +%s)
# Why I need an 1h offset to get the right value? Is it for the daylight setting?
echo  $task$(date +"%kh:%Mm" --date="@$(($end - $begin - 3600))")
