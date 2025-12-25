#!/usr/bin/env bash
# Golang installer - OS-agnostic
# Supports: brew, dnf, apt, or manual installation from official tarball

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

# Default Go version for manual installation
DEFAULT_GO_VERSION="1.23.0"
GO_VERSION="${INSTALL_GO_VERSION:-$DEFAULT_GO_VERSION}"
INSTALL_METHOD="${INSTALL_METHOD:-auto}"  # auto, package, tarball, gimme

install_go_from_package() {
    local pkg_manager=$(get_preferred_pkg_manager)
    print_info "Installing Go using $pkg_manager..."

    case "$pkg_manager" in
        dnf|apt|toolbox|distrobox)
            pkg_install "golang" "$pkg_manager"
            ;;
        brew)
            pkg_install "go" "$pkg_manager"
            ;;
        *)
            print_warning "No suitable package manager found"
            return 1
            ;;
    esac

    return 0
}

install_go_from_tarball() {
    print_info "Installing Go ${GO_VERSION} from official tarball..."

    local arch="amd64"
    if [[ "$(uname -m)" == "aarch64" ]]; then
        arch="arm64"
    fi

    local url="https://go.dev/dl/go${GO_VERSION}.linux-${arch}.tar.gz"
    local tarball="go${GO_VERSION}.linux-${arch}.tar.gz"

    # Download
    print_info "Downloading Go from $url..."
    if ! download_file "$url" "$tarball"; then
        print_error "Failed to download Go"
        return 1
    fi

    # Remove existing installation
    if [ -d /usr/local/go ]; then
        print_info "Removing existing Go installation..."
        sudo rm -rf /usr/local/go
    fi

    # Extract and install
    print_info "Installing to /usr/local/go..."
    sudo tar -C /usr/local -xzf "$tarball"

    # Cleanup
    rm -f "$tarball"

    # Add to PATH if not already there
    if ! grep -q '/usr/local/go/bin' ~/.bashrc 2>/dev/null; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        print_info "Added /usr/local/go/bin to PATH in ~/.bashrc"
    fi

    print_success "Go installed from tarball!"
}

install_gimme() {
    print_info "Installing gimme (Go version manager)..."

    mkdir -p ~/.local/bin

    if ! download_file "https://raw.githubusercontent.com/travis-ci/gimme/master/gimme" ~/.local/bin/gimme; then
        print_error "Failed to download gimme"
        return 1
    fi

    chmod +x ~/.local/bin/gimme

    # Add to PATH if not already there
    if ! grep -q '.local/bin' ~/.bashrc 2>/dev/null; then
        echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
        print_info "Added ~/.local/bin to PATH in ~/.bashrc"
    fi

    print_success "gimme installed! Use 'gimme <version>' to install Go versions"
}

main() {
    print_info "Starting Go installation..."

    # Check if already installed
    if pkg_is_installed go && [ "$INSTALL_METHOD" != "tarball" ] && [ "$INSTALL_METHOD" != "gimme" ]; then
        print_success "Go is already installed!"
        go version
        exit 0
    fi

    case "$INSTALL_METHOD" in
        package)
            install_go_from_package
            ;;
        tarball)
            install_go_from_tarball
            ;;
        gimme)
            install_gimme
            ;;
        auto)
            # Try package manager first, fall back to tarball
            if ! install_go_from_package; then
                print_warning "Package installation not available, installing from tarball..."
                install_go_from_tarball
            fi
            ;;
        *)
            print_error "Unknown install method: $INSTALL_METHOD"
            exit 1
            ;;
    esac

    # Verify installation
    if pkg_is_installed go; then
        print_success "Go installed successfully!"
        go version
    elif [ "$INSTALL_METHOD" = "gimme" ]; then
        print_success "gimme installed successfully!"
        print_info "Run 'gimme <version>' to install a Go version"
    else
        print_error "Go installation failed!"
        exit 1
    fi
}

main "$@"
