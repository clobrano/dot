#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

which dpkg >/dev/null
if [[ $? != 0 ]]; then
    echo "[!] Not debian based system. Skipping dependencies check"
else
    OK=$(dpkg -s python3-pip >/dev/null 2>&1)
    [[ "$OK" -eq 1 ]] && (echo "installing pip..."; sudo apt install -y python3-pip)

    OK=$(pip3 search tasklib)
    [[ ! $OK =~ "INSTALLED" ]] && (echo "installing tasklib..."; pip3 install --user tasklib)

    OK=$(pip3 search letsdo)
    [[ ! $OK =~ "INSTALLED" ]] && (echo "installing letsdo..."; pip3 install --user letsdo)
    echo [+] check dependencies OK
fi

HOOKS=~/MyBox/work/taskwarrior/hooks
[ ! -d ${HOOKS} ] && echo [!] could not find hook dir ${HOOKS} && exit 1
echo [+] check taskwarrior hook directory OK

PLUGINS="letsdo redtimer"
for PLUGIN in ${PLUGINS}; do
    ACTION=~/workspace/script-fu/${PLUGIN}-taskwarrior-hook.py
    [ ! -f ${ACTION} ] && echo [!] could not find action ${ACTION} && exit 1
    echo [+] check hook and action file for ${PLUGIN} OK

    ln -sf ${ACTION} ${HOOKS}/on-modify.${PLUGIN}
    echo [+] link hook and action file for ${PLUGIN} OK
done

echo [+] done.
