#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

DUE_TODAY=$(task +PENDING +TODAY count)
OVERDUE=$(task +OVERDUE count)
DUE_THIS_WEEK=$(task +PENDING due.after=sow due.before=eow count)
ACTIVE=$(task +ACTIVE count)
# `count` command doesn't seem to work with `completed` items
DONE_THIS_WEEK=$(task completed end.after=sow end.before=eow | grep -E "^ -" -c)

echo 󰻌 ${OVERDUE} 󱄻 ${DUE_TODAY} 󰫚 ${ACTIVE} 󰚻 ${DUE_THIS_WEEK} 󰕥 ${DONE_THIS_WEEK}
