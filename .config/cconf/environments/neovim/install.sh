#!/usr/bin/env bash
# Neovim installer - OS-agnostic

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

BUILD_FROM_SOURCE="${BUILD_FROM_SOURCE:-false}"
NVIMDIR="${HOME}/workspace/neovim"

install_neovim_from_package() {
    local pkg_manager=$(get_preferred_pkg_manager)
    print_info "Installing Neovim using $pkg_manager..."

    case "$pkg_manager" in
        dnf|apt)
            pkg_install "neovim" "$pkg_manager"
            ;;
        brew)
            pkg_install "neovim" "$pkg_manager"
            ;;
        flatpak)
            flatpak install -y flathub io.neovim.nvim
            ;;
        toolbox|distrobox)
            pkg_install "neovim" "$pkg_manager"
            ;;
        *)
            print_warning "No suitable package manager found, building from source..."
            return 1
            ;;
    esac

    # Install Python neovim package for plugin support
    if command -v pip3 &> /dev/null; then
        pip3 install --user --upgrade pynvim
    fi

    return 0
}

install_build_dependencies() {
    local pkg_manager=$(get_preferred_pkg_manager)
    print_info "Installing build dependencies..."

    case "$pkg_manager" in
        dnf|toolbox|distrobox)
            pkg_install_bulk "$pkg_manager" \
                ninja-build libtool autoconf automake cmake \
                gcc gcc-c++ make pkgconfig unzip patch gettext curl
            ;;
        apt)
            pkg_install_bulk "$pkg_manager" \
                ninja-build gettext libtool libtool-bin autoconf \
                automake cmake g++ pkg-config unzip curl doxygen
            ;;
        brew)
            pkg_install_bulk "$pkg_manager" \
                ninja libtool automake cmake pkg-config gettext
            ;;
        *)
            print_error "Cannot install build dependencies for $pkg_manager"
            return 1
            ;;
    esac
}

build_neovim_from_source() {
    print_info "Building Neovim from source..."

    # Install build dependencies
    install_build_dependencies

    # Create workspace directory
    [[ ! -d "${HOME}/workspace" ]] && mkdir -pv "${HOME}/workspace"

    # Clone or update repository
    if [[ ! -d "${NVIMDIR}" ]]; then
        print_info "Cloning Neovim repository..."
        git clone https://github.com/neovim/neovim "${NVIMDIR}"
    else
        print_info "Updating Neovim repository..."
        pushd "${NVIMDIR}" > /dev/null
        git pull
        popd > /dev/null
    fi

    # Build and install
    pushd "${NVIMDIR}" > /dev/null
    print_info "Checking out stable branch..."
    git checkout stable

    print_info "Building Neovim (this may take a while)..."
    make -j$(nproc) CMAKE_BUILD_TYPE=RelWithDebInfo

    print_info "Installing Neovim..."
    sudo make install
    popd > /dev/null

    # Install Python neovim package
    if command -v pip3 &> /dev/null; then
        pip3 install --user --upgrade pynvim
    fi

    print_success "Neovim built and installed from source!"
}

main() {
    print_info "Starting Neovim installation..."

    # Check if already installed
    if pkg_is_installed nvim && [ "$BUILD_FROM_SOURCE" != "true" ]; then
        print_success "Neovim is already installed!"
        nvim --version | head -1
        exit 0
    fi

    # Try package manager first, unless explicitly building from source
    if [ "$BUILD_FROM_SOURCE" = "true" ]; then
        build_neovim_from_source
    else
        if ! install_neovim_from_package; then
            print_warning "Package installation failed, trying to build from source..."
            build_neovim_from_source
        fi
    fi

    # Verify installation
    if pkg_is_installed nvim; then
        print_success "Neovim installed successfully!"
        nvim --version | head -1
    else
        print_error "Neovim installation failed!"
        exit 1
    fi
}

main "$@"
