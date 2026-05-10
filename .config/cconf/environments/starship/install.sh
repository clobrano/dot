#!/usr/bin/env bash
# Starship prompt installer - Uses official installer script only

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

install_starship() {
    print_info "Installing Starship using official installer script..."

    if ! command -v curl &> /dev/null; then
        print_error "curl is required to install Starship"
        exit 1
    fi

    # Use official installer (always use script, not package managers)
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    print_success "Starship installed via official script"
}

configure_shell() {
    print_info "Configuring shell integration..."

    # Bash configuration
    if [ -f ~/.bashrc ]; then
        if ! grep -q 'starship init bash' ~/.bashrc; then
            echo '' >> ~/.bashrc
            echo '# Starship prompt' >> ~/.bashrc
            echo 'eval "$(starship init bash)"' >> ~/.bashrc
            print_success "Added Starship to ~/.bashrc"
        else
            print_info "Starship already configured in ~/.bashrc"
        fi
    fi

    # Zsh configuration
    if [ -f ~/.zshrc ]; then
        if ! grep -q 'starship init zsh' ~/.zshrc; then
            echo '' >> ~/.zshrc
            echo '# Starship prompt' >> ~/.zshrc
            echo 'eval "$(starship init zsh)"' >> ~/.zshrc
            print_success "Added Starship to ~/.zshrc"
        else
            print_info "Starship already configured in ~/.zshrc"
        fi
    fi

    print_info "Restart your shell to see the new prompt!"
}

main() {
    print_info "Starting Starship installation..."

    # Check if already installed
    if pkg_is_installed starship; then
        print_success "Starship is already installed!"
        starship --version
        configure_shell
        exit 0
    fi

    # Install using official script
    install_starship

    # Verify installation
    if pkg_is_installed starship; then
        print_success "Starship installed successfully!"
        starship --version
        configure_shell
    else
        print_error "Starship installation failed!"
        exit 1
    fi
}

main "$@"
