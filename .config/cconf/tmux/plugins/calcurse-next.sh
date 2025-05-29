#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

calcurse --next | tail -1 | awk '{$1=$1;print}'
