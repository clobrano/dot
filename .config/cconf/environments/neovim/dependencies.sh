#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## This script installs dependencies that neovim is not able to install or expect the system to have it already.
## created 2025-01-10 for bash LSP that does not instal a language server apparently, so using https://github.com/bash-lsp/bash-language-server

sudo dnf install -y nodejs-bash-language-server
