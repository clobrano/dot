#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

# Use default taskwarrior binary if not set externally
: ${TASK:="task rc:~/.taskworkrc"}
DUE_TODAY=$(${TASK} +PENDING +TODAY count)
[ $? -ne 0 ] && cat ~/.taskwarrior-stats && exit 0
OVERDUE=$(${TASK} +OVERDUE count)
[ $? -ne 0 ] && cat ~/.taskwarrior-stats && exit 0
DUE_THIS_WEEK=$(${TASK} +PENDING due.after=sow due.before=eow count)
[ $? -ne 0 ] && cat ~/.taskwarrior-stats && exit 0
ACTIVE=$(${TASK} +ACTIVE count)
[ $? -ne 0 ] && cat ~/.taskwarrior-stats && exit 0
# `count` command doesn't seem to work with `completed` items
DONE_THIS_WEEK=$(${TASK} completed end.after=sow end.before=eow | grep -E "^ -" -c)
[ $? -ne 0 ] && cat ~/.taskwarrior-stats && exit 0

echo 󰻌 ${OVERDUE:-?} 󱄻 ${DUE_TODAY:-?} 󰫚 ${ACTIVE:-?} 󰚻 ${DUE_THIS_WEEK:-?} 󰕥 ${DONE_THIS_WEEK:-?} | tee ~/.taskwarrior-stats
