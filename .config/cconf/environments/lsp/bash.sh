#!/usr/bin/env bash
# Bash LSP installer - OS-agnostic
# Installs bash-language-server

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

print_info "Installing Bash Language Server..."

# Try package manager first (Fedora has nodejs-bash-language-server)
PKG_MANAGER=$(get_preferred_pkg_manager)

install_from_package() {
    case "$PKG_MANAGER" in
        dnf|toolbox|distrobox)
            print_info "Installing via $PKG_MANAGER..."
            pkg_install "nodejs-bash-language-server" "$PKG_MANAGER"
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

install_from_npm() {
    print_info "Installing via npm..."

    # Check if npm is available
    if ! command -v npm &> /dev/null; then
        print_error "npm not found!"
        print_info "Please install Node.js and npm first:"
        print_info "  Fedora: sudo dnf install nodejs"
        print_info "  Brew: brew install node"
        exit 1
    fi

    # Install globally
    npm install -g bash-language-server

    print_success "Bash Language Server installed via npm"
}

# Try package manager first, fall back to npm
if ! install_from_package; then
    install_from_npm
fi

# Verify installation
if command -v bash-language-server &> /dev/null; then
    print_success "Bash Language Server installed successfully!"
    bash-language-server --version
else
    print_error "Installation failed - bash-language-server not found in PATH"
    exit 1
fi
