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
            "luarocks"
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
            "luarocks"
        )
        ;;
esac

print_info "Using package manager: $PKG_MANAGER"

# Install dependencies
for dep in "${DEPENDENCIES[@]}"; do
    pkg_install "$dep" "$PKG_MANAGER"
done

# Install tree-sitter CLI using cargo
print_info "Installing tree-sitter CLI..."

# Source cargo environment if it exists (needed after fresh rust install)
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if command -v cargo &> /dev/null; then
    if ! command -v tree-sitter &> /dev/null; then
        cargo install tree-sitter-cli
        print_success "tree-sitter CLI installed!"
    else
        print_success "tree-sitter CLI already installed!"
    fi
else
    print_warning "Cargo not found, skipping tree-sitter CLI installation"
    print_warning "Run 'make rust' to install Rust/Cargo first"
fi

print_success "Neovim dependencies installed successfully!"
