#!/usr/bin/env bash
# Fedora OS bootstrap script
# Sets up DNF configuration, base packages, RPM Fusion, and media codecs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

DNF_CONF="/etc/dnf/dnf.conf"

configure_dnf() {
    print_info "Configuring DNF for faster downloads..."

    if grep -q max_parallel_downloads "$DNF_CONF" 2>/dev/null; then
        print_info "DNF already configured"
        return 0
    fi

    print_info "Adding max_parallel_downloads and fastestmirror to $DNF_CONF"

    sudo tee -a "$DNF_CONF" > /dev/null <<EOF
max_parallel_downloads=10
fastestmirror=true
EOF

    print_success "DNF configured successfully"
}

install_base_packages() {
    print_info "Installing base packages..."

    # Base packages (cleaned - removed neovim-specific tools, atuin, conserver-client)
    # Removed: cscope, ctags, fzf, the_silver_searcher, ripgrep (moved to neovim/dependencies.sh)
    # Removed: neovim (installed via environments/neovim/install.sh)
    # Removed: golang (installed via environments/golang/install.sh)
    # Removed: task (installed via environments/taskwarrior/install.sh)
    # Removed: atuin (user doesn't want it)
    # Removed: conserver-client (user doesn't recall needing it)
    # Removed: xclip, deja-dup, recode (user doesn't need them)

    local packages=(
        alacritty
        bat
        bear
        clang
        clang-tools-extra
        curl
        eza
        fd-find
        gh
        git
        python3-pip
        stow
        tmux
        yq
        zsh
    )

    print_info "Installing ${#packages[@]} base packages..."
    sudo dnf install -y --skip-unavailable "${packages[@]}"

    print_success "Base packages installed"
}

initialize_git_submodules() {
    print_info "Initializing git submodules..."

    local dotfiles_dir="$HOME/.dot"

    if [ -d "$dotfiles_dir/.git" ]; then
        pushd "$dotfiles_dir" > /dev/null
        git submodule update --init --recursive
        popd > /dev/null
        print_success "Git submodules initialized"
    else
        print_warning "Not in a git repository, skipping submodules"
    fi
}

main() {
    print_info "Starting Fedora OS bootstrap..."

    # Verify we're on Fedora
    detect_os
    if [ "$OS_ID" != "fedora" ]; then
        print_error "This script is for Fedora only! Detected OS: $OS_ID"
        exit 1
    fi

    print_info "Detected: $OS_NAME (Variant: $OS_VARIANT)"

    # Step 1: Configure DNF
    configure_dnf

    # Step 2: Install base packages
    install_base_packages

    # Step 3: Initialize git submodules
    initialize_git_submodules

    print_success "Fedora OS bootstrap completed successfully!"
    echo ""
    print_info "Next steps:"
    print_info "  1. Install CLI tools: make all (or make dev for dev tools only)"
    print_info "  2. Install RPM Fusion & media codecs (optional): make rpmfusion"
    print_info "  3. Install GUI apps (optional): make flatpak-apps"
    print_info "  4. Or run individual targets: make neovim golang lsp taskwarrior starship"
    echo ""
    print_info "Run 'make help' to see all available targets"
}

main "$@"
