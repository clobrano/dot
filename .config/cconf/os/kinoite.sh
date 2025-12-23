#!/usr/bin/env bash
# Immutable OS (Kinoite/Silverblue) bootstrap script
# Sets up Homebrew, toolbox/distrobox, and Flatpak

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

install_homebrew() {
    if command -v brew &> /dev/null; then
        print_success "Homebrew is already installed"
        return 0
    fi

    print_info "Installing Homebrew..."

    if ! command -v curl &> /dev/null; then
        print_error "curl is required to install Homebrew"
        exit 1
    fi

    # Install Homebrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        # Add to shell config
        local brew_init='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

        if [ -f ~/.bashrc ] && ! grep -q "linuxbrew" ~/.bashrc; then
            echo '' >> ~/.bashrc
            echo '# Homebrew' >> ~/.bashrc
            echo "$brew_init" >> ~/.bashrc
            print_success "Added Homebrew to ~/.bashrc"
        fi

        if [ -f ~/.zshrc ] && ! grep -q "linuxbrew" ~/.zshrc; then
            echo '' >> ~/.zshrc
            echo '# Homebrew' >> ~/.zshrc
            echo "$brew_init" >> ~/.zshrc
            print_success "Added Homebrew to ~/.zshrc"
        fi
    fi

    print_success "Homebrew installed successfully!"
}

install_base_brew_packages() {
    print_info "Installing base packages via Homebrew..."

    # Check if brew is available
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew not found!"
        return 1
    fi

    local packages=(
        bat
        eza
        fd
        fzf
        gh
        git
        ripgrep
        stow
        tmux
        zsh
    )

    print_info "Installing ${#packages[@]} base packages..."
    brew install "${packages[@]}"

    print_success "Base packages installed via Homebrew"
}

setup_toolbox() {
    if ! command -v toolbox &> /dev/null; then
        print_warning "toolbox not found. Install it using: rpm-ostree install toolbox"
        print_info "After installing, run: systemctl reboot"
        return 1
    fi

    print_info "Setting up toolbox container..."

    # Check if a Fedora toolbox already exists
    if toolbox list 2>/dev/null | grep -q "fedora-toolbox"; then
        print_success "Fedora toolbox already exists"
        return 0
    fi

    # Create Fedora toolbox
    print_info "Creating Fedora toolbox (this may take a while)..."
    toolbox create -y fedora-toolbox

    print_success "Fedora toolbox created!"
    print_info "Enter the toolbox with: toolbox enter fedora-toolbox"
}

setup_distrobox() {
    if ! command -v distrobox &> /dev/null; then
        print_warning "distrobox not found. Install it using: rpm-ostree install distrobox"
        print_info "After installing, run: systemctl reboot"
        return 1
    fi

    print_info "Setting up distrobox container..."

    # Check if a Fedora distrobox already exists
    if distrobox list 2>/dev/null | grep -q "fedora"; then
        print_success "Fedora distrobox already exists"
        return 0
    fi

    # Create Fedora distrobox
    print_info "Creating Fedora distrobox (this may take a while)..."
    distrobox create --name fedora --image registry.fedoraproject.org/fedora-toolbox:latest

    print_success "Fedora distrobox created!"
    print_info "Enter the distrobox with: distrobox enter fedora"
}

enable_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        print_error "Flatpak not found! It should be pre-installed on Kinoite/Silverblue"
        return 1
    fi

    print_info "Configuring Flatpak..."

    # Add Flathub if not already added
    if ! flatpak remotes | grep -q flathub; then
        print_info "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    else
        print_success "Flathub already configured"
    fi

    print_success "Flatpak configured"
}

install_flatpak_apps() {
    print_info "Installing Flatpak applications..."

    local flatpak_script="$SCRIPT_DIR/../environments/flatpak-install-apps.sh"

    if [ -f "$flatpak_script" ]; then
        print_info "Running Flatpak apps installation..."
        bash "$flatpak_script"
    else
        print_warning "Flatpak apps script not found at $flatpak_script"
        print_info "You can install apps manually with: flatpak install flathub <app-id>"
    fi
}

install_essential_rpms() {
    print_info "Some packages need to be layered on the immutable OS..."
    print_warning "This requires a reboot after installation!"

    local essential_rpms=(
        "toolbox"
        "distrobox"
    )

    local to_install=()

    for rpm in "${essential_rpms[@]}"; do
        if ! rpm -q "$rpm" &> /dev/null; then
            to_install+=("$rpm")
        fi
    done

    if [ ${#to_install[@]} -eq 0 ]; then
        print_success "All essential RPMs already installed"
        return 0
    fi

    print_warning "The following packages will be layered: ${to_install[*]}"
    print_warning "This will require a reboot. Continue? (y/N)"
    read -r response

    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Skipping RPM installation"
        return 0
    fi

    print_info "Installing: ${to_install[*]}"
    rpm-ostree install "${to_install[@]}"

    print_success "RPMs installed! Please reboot your system."
    print_info "After reboot, run this script again to continue setup."
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

print_usage_guide() {
    print_success "Immutable OS setup completed!"
    echo ""
    print_info "=== Package Manager Guide ==="
    echo ""
    print_info "1. GUI Applications → Use Flatpak"
    echo "   flatpak install flathub <app-id>"
    echo ""
    print_info "2. CLI Tools & Development → Use Homebrew"
    echo "   brew install <package>"
    echo ""
    print_info "3. Fedora-specific packages → Use toolbox/distrobox"
    echo "   toolbox enter fedora-toolbox"
    echo "   sudo dnf install <package>"
    echo ""
    print_info "4. System components (rare) → Layer with rpm-ostree"
    echo "   rpm-ostree install <package>"
    echo "   systemctl reboot"
    echo ""
    print_info "Next steps:"
    print_info "  - Run 'make all' to install development tools"
    print_info "  - Or run individual targets: 'make neovim golang lsp taskwarrior starship'"
}

main() {
    print_info "Starting Immutable OS (Kinoite/Silverblue) bootstrap..."

    # Verify we're on an immutable OS
    detect_os
    if [ "$OS_VARIANT" != "immutable" ]; then
        print_warning "This script is optimized for immutable Fedora variants (Kinoite/Silverblue)"
        print_warning "Detected variant: $OS_VARIANT"
        print_info "Consider using os/fedora.sh instead"
        echo ""
        read -p "Continue anyway? (y/N) " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi

    print_info "Detected: $OS_NAME (Variant: $OS_VARIANT)"

    # Step 1: Install essential RPMs if needed
    install_essential_rpms

    # Step 2: Enable and configure Flatpak
    enable_flatpak

    # Step 3: Install Flatpak apps
    install_flatpak_apps

    # Step 4: Install Homebrew
    install_homebrew

    # Step 5: Install base packages via Homebrew
    if command -v brew &> /dev/null; then
        install_base_brew_packages
    fi

    # Step 6: Setup container environment (toolbox or distrobox)
    if command -v toolbox &> /dev/null; then
        setup_toolbox
    elif command -v distrobox &> /dev/null; then
        setup_distrobox
    else
        print_warning "Neither toolbox nor distrobox available"
        print_info "Reboot and run this script again to set up containers"
    fi

    # Step 7: Initialize git submodules
    initialize_git_submodules

    # Print usage guide
    print_usage_guide
}

main "$@"
