#!/usr/bin/env bash
# Rust/Cargo installer - OS-agnostic
# Supports: rustup (recommended), brew, dnf, apt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

INSTALL_METHOD="${INSTALL_METHOD:-auto}"  # auto, package, rustup

install_rust_from_package() {
    local pkg_manager=$(get_preferred_pkg_manager)
    print_info "Installing Rust using $pkg_manager..."

    case "$pkg_manager" in
        dnf|apt|toolbox|distrobox)
            pkg_install "rust" "$pkg_manager"
            pkg_install "cargo" "$pkg_manager"
            ;;
        brew)
            pkg_install "rust" "$pkg_manager"
            ;;
        *)
            print_warning "No suitable package manager found"
            return 1
            ;;
    esac

    return 0
}

install_rust_from_rustup() {
    print_info "Installing Rust using rustup (official installer)..."

    # Check if rustup is already installed
    if command -v rustup &> /dev/null; then
        print_info "rustup is already installed, updating..."
        rustup update
        return 0
    fi

    # Download and run rustup installer
    print_info "Downloading rustup installer..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Source cargo environment
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi

    print_success "Rust installed via rustup!"
}

main() {
    print_info "Starting Rust installation..."

    # Check if already installed
    if pkg_is_installed cargo && [ "$INSTALL_METHOD" != "rustup" ]; then
        print_success "Rust/Cargo is already installed!"
        rustc --version
        cargo --version
        exit 0
    fi

    case "$INSTALL_METHOD" in
        package)
            install_rust_from_package
            ;;
        rustup)
            install_rust_from_rustup
            ;;
        auto)
            # Prefer rustup for better version management and completeness
            print_info "Using rustup (recommended method)..."
            install_rust_from_rustup
            ;;
        *)
            print_error "Unknown install method: $INSTALL_METHOD"
            exit 1
            ;;
    esac

    # Verify installation
    if pkg_is_installed cargo; then
        print_success "Rust/Cargo installed successfully!"
        rustc --version
        cargo --version
    else
        print_error "Rust installation failed!"
        exit 1
    fi
}

main "$@"
