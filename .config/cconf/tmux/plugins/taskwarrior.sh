#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
DEBUG=1
command -v task >/dev/null
if [[ $? -ne 0 ]]; then
    exit 0
fi

check-error() {
    previouserror=$1
    if [ $previouserror -ne 0 ]; then
        [[ $DEBUG -eq 1 ]] && echo "error $previouserror, printing default"
        cat ~/.taskwarrior-stats && exit 0
    fi
}

# Use default taskwarrior binary if not set externally
: ${TASK:="task rc:~/.taskworkrc"}
## Ignore "no matches" error
DUE_TODAY=$(${TASK} +PENDING +TODAY count)
[[ $DUE_TODAY -gt 0 ]] && check-error $?

OVERDUE=$(${TASK} +OVERDUE count)
[[ $OVERDUE -gt 0 ]] && check-error $?

DUE_THIS_WEEK=$(${TASK} +PENDING due.after=sow due.before=eow count)
[[ $DUE_THIS_WEEK -gt 0 ]] && check-error $?

ACTIVE=$(${TASK} +ACTIVE count)
[[ $ACTIVE -gt 0 ]] && check-error $?

# `count` command doesn't seem to work with `completed` items
DONE_THIS_WEEK=$(${TASK} completed end.after=sow end.before=eow | grep -E "^ -" -c)
[[ $DONE_THIS_WEEK -gt 0 ]] && check-error $?

echo 󰻌 ${OVERDUE:-?} 󱄻 ${DUE_TODAY:-?} 󰫚 ${ACTIVE:-?} 󰚻 ${DUE_THIS_WEEK:-?} 󰕥 ${DONE_THIS_WEEK:-?} | tee ~/.taskwarrior-stats
