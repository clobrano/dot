#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

NEXT_APPOINTMENT=$(calcurse --next | tail -1 | awk '{$1=$1;print}')
echo " ${NEXT_APPOINTMENT:-"No events"}"
