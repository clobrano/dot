#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
print_tdd_status() {
    # if result file exists
    #   if success > display green light
    #   if error > display red light
    # else do nothing

    tdd_result_location=${TDD_RESULT_LOCATION:-~/.tdd-result}
    if [[ ! -f ${tdd_result_location} ]]; then
        echo "no tdd"
    else
        result=$(cat ${tdd_result_location})
        if cat ${tdd_result_location} | grep -ci "OK"; then
            echo "#[fg=green]${result}"
        else
            echo "#[fg=red]${result}"
        fi
    fi
}

print_tdd_status
