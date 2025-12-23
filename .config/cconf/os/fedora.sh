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

    local packages=(
        alacritty
        bat
        bear
        clang
        clang-tools-extra
        curl
        deja-dup
        eza
        fd-find
        gh
        git
        python3-pip
        recode
        stow
        tmux
        xclip
        yq
        zsh
    )

    print_info "Installing ${#packages[@]} base packages..."
    sudo dnf install -y "${packages[@]}"

    print_success "Base packages installed"
}

enable_rpm_fusion() {
    print_info "Enabling RPM Fusion repositories..."

    # Check if RPM Fusion is already installed
    if rpm -q rpmfusion-free-release &> /dev/null; then
        print_info "RPM Fusion already enabled"
        return 0
    fi

    local fedora_version=$(rpm -E %fedora)

    print_info "Installing RPM Fusion Free..."
    sudo dnf install -y \
        "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm"

    print_info "Installing RPM Fusion Nonfree..."
    sudo dnf install -y \
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"

    print_info "Updating core group..."
    sudo dnf group update core -y

    print_success "RPM Fusion enabled"
}

install_media_codecs() {
    print_info "Installing multimedia codecs..."

    print_info "Installing GStreamer plugins..."
    sudo dnf install -y \
        gstreamer1-plugins-{bad-\*,good-\*,base} \
        gstreamer1-plugin-openh264 \
        gstreamer1-libav \
        --exclude=gstreamer1-plugins-bad-free-devel

    print_info "Installing LAME..."
    sudo dnf install -y lame\* --exclude=lame-devel

    print_info "Upgrading multimedia groups..."
    sudo dnf group upgrade --with-optional Multimedia -y
    sudo dnf group update multimedia sound-and-video -y

    print_success "Media codecs installed"
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

    # Step 3: Enable RPM Fusion
    enable_rpm_fusion

    # Step 4: Install media codecs
    install_media_codecs

    # Step 5: Initialize git submodules
    initialize_git_submodules

    print_success "Fedora OS bootstrap completed successfully!"
    echo ""
    print_info "Next steps:"
    print_info "  1. Install CLI tools: make all (or make dev for dev tools only)"
    print_info "  2. Install GUI apps (optional): make flatpak-apps"
    print_info "  3. Or run individual targets: make neovim golang lsp taskwarrior starship"
    echo ""
    print_info "Run 'make help' to see all available targets"
}

main "$@"
