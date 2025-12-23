#!/usr/bin/env bash
# Neovim dependencies installer
# Installs CLI tools that Neovim plugins depend on

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

print_info "Installing Neovim dependencies..."

# Core dependencies for Neovim plugins:
# - cscope: Code browsing and navigation
# - ctags: Tag generation for code navigation
# - fzf: Fuzzy finder (used by many plugins)
# - the_silver_searcher (ag): Fast code search
# - ripgrep (rg): Even faster code search (used by Telescope)

DEPENDENCIES=(
    "cscope"
    "ctags"
    "fzf"
    "the_silver_searcher"
    "ripgrep"
)

PKG_MANAGER=$(get_preferred_pkg_manager)

# Map package names for different package managers
case "$PKG_MANAGER" in
    brew)
        # Homebrew uses different names
        DEPENDENCIES=(
            "cscope"
            "ctags"
            "fzf"
            "the_silver_searcher"
            "ripgrep"
        )
        ;;
    apt)
        # Debian/Ubuntu package names
        DEPENDENCIES=(
            "cscope"
            "exuberant-ctags"
            "fzf"
            "silversearcher-ag"
            "ripgrep"
        )
        ;;
    *)
        # Fedora/DNF uses standard names
        DEPENDENCIES=(
            "cscope"
            "ctags"
            "fzf"
            "the_silver_searcher"
            "ripgrep"
        )
        ;;
esac

print_info "Using package manager: $PKG_MANAGER"

# Install dependencies
for dep in "${DEPENDENCIES[@]}"; do
    pkg_install "$dep" "$PKG_MANAGER"
done

print_success "Neovim dependencies installed successfully!"
