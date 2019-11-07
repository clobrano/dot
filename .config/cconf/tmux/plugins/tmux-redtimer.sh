#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# show redtimer end session time on tmux

function time_left() {
    TIME1=`date +%H:%M`
    TIME2=$(echo $1 | cut -d' ' -f3)

    # Convert the times to seconds from the Epoch
    SEC1=`date +%s -d ${TIME1}`
    SEC2=`date +%s -d ${TIME2}`

    # Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
    DIFFSEC=`expr ${SEC2} - ${SEC1}`
    echo `date +%H:%M -ud @${DIFFSEC}`
}

function get_icon() {
    [ -f /tmp/redtimer-work-job ] && icon=' '
    [ -f /tmp/redtimer-pause-job ] && icon=' '
    echo "$icon"
}
function get_job_id() {
    [ -f /tmp/redtimer-work-job ] && job_id=`cat -v /tmp/redtimer-work-job`
    [ -f /tmp/redtimer-pause-job ] && job_id=`cat -v /tmp/redtimer-pause-job`
    echo "$job_id"
}

function get_end_time() {
    job_id=$1
    end_time=`atq | grep $job_id | cut -d" " -f2,3,4,5`
    echo "$end_time"
}

exists=$(which redtimer | grep home | wc -l)

if [[ $exists == 1 ]]; then
    job_id=$(get_job_id)
    end_time=$(get_end_time $job_id)
    icon=$(get_icon)
    echo " $icon" -$(time_left "$end_time")
fi
