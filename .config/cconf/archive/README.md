# Archive

This directory contains old scripts that have been replaced by the new reorganized structure.

## Contents

### fedora/
Old Fedora-specific setup scripts (replaced by `os/fedora.sh`)
- 00-fedora-init.sh - Old orchestrator script
- 01-fedora-dnf-speed-up.sh
- 02-dnf-install-base-requirements.sh
- 03-fedora-enable-rpm-fusion.sh
- 04-fedora-install-media-codecs.sh

### golang/
Old Go installation scripts (replaced by `environments/golang/install.sh`)
- golang.sh - Direct Go installation from tarball
- gimme-go-installer.sh - Gimme version manager
- delve-debugger-install.sh - Delve debugger (Fedora-specific)

### lsp/
Old LSP installation scripts (replaced by `environments/lsp/python.sh` and `environments/lsp/bash.sh`)
- python-lsp.sh - Old Python LSP installer
- c-cpp.lsp.sh - C/C++ LSP (not migrated)
- yaml-lsp.sh - YAML LSP (not migrated)

### neovim/
Old Neovim installation scripts (replaced by `environments/neovim/install.sh` and `environments/neovim/dependencies.sh`)
- neovim-build-from-source.sh - Build Neovim from source
- neovim-qt.sh - Neovim Qt GUI (Ubuntu-specific)
- taskwiki-setup.sh - Taskwiki plugin setup (no longer needed)

### taskwarrior/
Old Taskwarrior installation script (replaced by `environments/taskwarrior/install.sh`)
- taskwarrior-install-and-setup.sh - Old installer

### old-scripts/
Various standalone scripts that are no longer needed:
- atuin-setup-and-install.sh - Atuin shell history (removed from requirements)
- batch-install.sh - Old batch installer (replaced by `lib/install.sh`)
- docker-install-upgrade-remove.sh - Docker installer
- flutter-install-and-setup.sh - Flutter SDK
- kubernetes/ - Kubernetes tools
- pyenv-* - Python version manager
- rust-install-and-setup.sh - Rust installer (now handled by taskwarrior script)
- And many others...

## Why Archived?

These scripts were archived during a reorganization to:
1. Consolidate redundant installers
2. Add OS detection and cross-platform support
3. Implement a Makefile-based workflow
4. Remove unused/unwanted tools
5. Separate OS-specific from tool-specific configuration

## Can I Use These?

Yes, but they're not maintained. The new scripts in the parent directory are recommended.

If you need functionality from an archived script that isn't in the new structure,
you can adapt it or submit a request to add it back.
