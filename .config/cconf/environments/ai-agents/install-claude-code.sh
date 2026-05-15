#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

if command -v claude 2>&1 > /dev/null; then
    echo "[!] Claude Code already installed"
    exit 0
fi
curl -fsSL https://claude.ai/install.sh | bash
