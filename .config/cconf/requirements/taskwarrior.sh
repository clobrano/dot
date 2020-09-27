#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -e

echo [+] installing dependencies
sudo apt install -y python3-pip
pip3 install --user tasklib
pip3 install --user letsdo

echo [+] checking hook and action file...
HOOKS=~/MyBox/work/taskwarrior/hooks
ACTION=~/workspace/script-fu/letsdo-taskwarrior-hook.py
[ ! -d ${HOOKS} ] && echo [!] could not find hook dir ${HOOKS} && exit 1
[ ! -f ${ACTION} ] && echo [!] could not find action ${ACTION} && exit 1

echo [+] linking hook and action file...
ln -s ${ACTION} ${HOOKS}/on-modify.letsdo

echo [+] taskwarrior diagnostic
task diagnostic

echo [+] done.
