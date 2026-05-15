#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

if command -v gemini 2>&1 > /dev/null; then
    echo "[!] Gemini CLI already installed"
    exit 0
fi
npm install -g @google/gemini-cli
