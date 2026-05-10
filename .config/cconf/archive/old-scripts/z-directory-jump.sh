#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
if [[ ! -f z.sh ]]; then
    wget https://raw.githubusercontent.com/rupa/z/master/z.sh
fi

mv z.sh $HOME/.config/cconf/requirements
