#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
print_cpu_temp() {
    if [[ $(which sensors | wc -l) -eq 1 ]]; then
        local temp
        temp=$(sensors | sed -n '/^Package/p' | awk '{a=$4} END {printf("%3.1f", a)}')
        echo '' "$temp"C
    else
        echo ""
    fi
}

print_cpu_temp
