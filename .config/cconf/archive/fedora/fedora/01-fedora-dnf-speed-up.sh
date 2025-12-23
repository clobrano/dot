#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
DNF_CONF=/etc/dnf/dnf.conf

if grep max_parallel_downloads $DNF_CONF >/dev/null; then
    echo [+] $DNF_CONF is already configured.
    exit 0
fi

sudo cat <<EOF >> ${DNF_CONF}
max_parallel_downloads=10
fastestmirror=true
EOF
