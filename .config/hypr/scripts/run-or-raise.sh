#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

pgrep "$1" && hyprctl dispatch focuswindow "$1" || "$1"
