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

get_latest_stable_github_version() {
    local latest_url="https://api.github.com/repos/neovim/neovim/releases/latest"
    local response

    if ! response=$(curl -fsSL "$latest_url" 2>/dev/null); then
        print_error "Failed to reach GitHub API. Check your network connection." >&2
        exit 1
    fi
    if [ -z "$response" ]; then
        print_error "Empty response from GitHub API." >&2
        exit 1
    fi

    local version=""
    if command -v jq &>/dev/null; then
        version=$(echo "$response" | jq -r '.tag_name // empty' 2>/dev/null)
    else
        version=$(echo "$response" \
            | grep -o '"tag_name": "v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"' \
            | grep -o 'v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*' | head -1)
    fi

    # Fallback: query release-x.y branches
    if [ -z "$version" ]; then
        local branches_url="https://api.github.com/repos/neovim/neovim/branches?per_page=100"
        local branches_response

        if ! branches_response=$(curl -fsSL "$branches_url" 2>/dev/null); then
            print_error "Failed to reach GitHub branches API. Check your network connection." >&2
            exit 1
        fi
        if [ -z "$branches_response" ]; then
            print_error "Empty response from GitHub branches API." >&2
            exit 1
        fi

        local latest_branch=""
        if command -v jq &>/dev/null; then
            latest_branch=$(echo "$branches_response" \
                | jq -r '[.[] | select(.name | test("^release-[0-9]+\\.[0-9]+$")) | .name] | sort_by(split("-")[1] | split(".") | map(tonumber)) | last // empty' 2>/dev/null)
        else
            latest_branch=$(echo "$branches_response" \
                | grep -o '"name": "release-[0-9][0-9]*\.[0-9][0-9]*"' \
                | grep -o 'release-[0-9][0-9]*\.[0-9][0-9]*' \
                | sort -V | tail -1)
        fi

        if [ -n "$latest_branch" ]; then
            version="${latest_branch#release-}.0"
        else
            print_error "Could not determine latest stable Neovim version from GitHub." >&2
            exit 1
        fi
    else
        version="${version#v}"
    fi

    print_info "Latest stable Neovim on GitHub: $version" >&2
    echo "$version"
}

get_installed_nvim_version() {
    if ! command -v nvim &>/dev/null; then
        echo ""
        return 0
    fi

    local raw
    raw=$(nvim --version 2>/dev/null | head -1)
    echo "$raw" | grep -o 'NVIM v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*' \
        | grep -o '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*'
}

check_nvim_version_and_prompt() {
    local latest installed

    latest=$(get_latest_stable_github_version) || exit 1
    installed=$(get_installed_nvim_version)

    if [ -z "$installed" ]; then
        print_info "Neovim is not installed. Will install latest stable ($latest)."
        return 0
    fi

    local cmp=0
    if version_compare "$installed" "$latest"; then
        cmp=0
    else
        cmp=$?
    fi

    if [ "$cmp" -eq 0 ] || [ "$cmp" -eq 1 ]; then
        print_success "Neovim $installed is already the latest stable version."
        exit 0
    fi

    # Newer version available
    print_info "Neovim $installed is installed. Neovim $latest is available."

    if [ "$BUILD_FROM_SOURCE" = "true" ]; then
        print_warning "Newer stable Neovim $latest is available. Proceeding with source build anyway..."
        return 0
    fi

    read -r -p "Would you like to upgrade? [y/N] " answer
    case "$answer" in
        [yY])
            export BUILD_FROM_SOURCE=true
            return 0 ;;
        *)
            print_info "Skipping upgrade."
            exit 0
            ;;
    esac
}

main() {
    print_info "Starting Neovim installation..."

    check_nvim_version_and_prompt

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

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
