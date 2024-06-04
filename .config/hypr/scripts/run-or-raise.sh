#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

pgrep firefox && hyprctl dispatch focuswindow "$1" || "$1"
