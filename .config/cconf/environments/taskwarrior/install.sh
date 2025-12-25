#!/usr/bin/env bash
# Taskwarrior installer with version check
# Only installs from repo if version >= 3.x, otherwise builds from source

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

# Versions
TASKWARRIOR_VERSION="${TASKWARRIOR_VERSION:-3.3.0}"
TASKWARRIOR_TUI_VERSION="${TASKWARRIOR_TUI_VERSION:-v0.26.3}"
MIN_REPO_VERSION="3.0.0"

install_python_dependencies() {
    print_info "Installing Python dependencies..."

    if ! command -v pip3 &> /dev/null; then
        print_error "pip3 not found! Please install Python 3 and pip first."
        exit 1
    fi

    pip3 install --user tasklib pynvim
    print_success "Python dependencies installed"
}

install_taskwarrior_tui() {
    print_info "Installing taskwarrior-tui ${TASKWARRIOR_TUI_VERSION}..."

    mkdir -p ~/.local/bin

    local arch="x86_64"
    if [[ "$(uname -m)" == "aarch64" ]]; then
        arch="aarch64"
    fi

    local archive="taskwarrior-tui-${arch}-unknown-linux-gnu.tar.gz"
    local url="https://github.com/kdheepak/taskwarrior-tui/releases/download/${TASKWARRIOR_TUI_VERSION}/${archive}"

    if ! download_file "$url" "$archive"; then
        print_error "Failed to download taskwarrior-tui"
        return 1
    fi

    tar xzf "$archive"
    mv taskwarrior-tui ~/.local/bin/
    rm -f "$archive"

    print_success "taskwarrior-tui installed to ~/.local/bin"
}

install_from_repo() {
    local pkg_manager=$(get_preferred_pkg_manager)
    print_info "Installing taskwarrior from repository using $pkg_manager..."

    case "$pkg_manager" in
        dnf)
            pkg_install "task" "$pkg_manager"
            ;;
        brew)
            pkg_install "taskwarrior" "$pkg_manager"
            ;;
        apt)
            pkg_install "taskwarrior" "$pkg_manager"
            ;;
        toolbox|distrobox)
            pkg_install "task" "$pkg_manager"
            ;;
        *)
            return 1
            ;;
    esac

    print_success "Taskwarrior installed from repository"
}

ensure_rust_installed() {
    if command -v rustc &> /dev/null; then
        print_success "Rust is already installed"
        return 0
    fi

    print_info "Rust is required to build Taskwarrior. Installing..."

    # Install Rust using rustup
    if ! command -v curl &> /dev/null; then
        print_error "curl is required to install Rust"
        exit 1
    fi

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Source cargo env
    source "$HOME/.cargo/env"

    print_success "Rust installed successfully"
}

build_from_source() {
    print_info "Building Taskwarrior ${TASKWARRIOR_VERSION} from source..."

    local package="task-${TASKWARRIOR_VERSION}"
    local archive="${package}.tar.gz"
    local url="https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TASKWARRIOR_VERSION}/${archive}"

    # Download source
    if [ ! -f "$archive" ]; then
        if ! download_file "$url" "$archive"; then
            print_error "Failed to download Taskwarrior source"
            exit 1
        fi
    fi

    # Install build dependencies
    local pkg_manager=$(get_preferred_pkg_manager)
    print_info "Installing build dependencies..."

    case "$pkg_manager" in
        dnf|toolbox|distrobox)
            pkg_install_bulk "$pkg_manager" cmake libuuid-devel
            ;;
        brew)
            pkg_install_bulk "$pkg_manager" cmake
            ;;
        apt)
            pkg_install_bulk "$pkg_manager" cmake uuid-dev
            ;;
    esac

    # Ensure Rust is installed
    ensure_rust_installed

    # Build
    mkdir -p ~/Apps
    cp "$archive" ~/Apps/
    pushd ~/Apps > /dev/null

    print_info "Extracting source..."
    tar xzf "$archive"

    pushd "$package" > /dev/null

    print_info "Configuring build..."
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release

    print_info "Building (this may take a while)..."
    cmake --build build

    print_info "Installing..."
    sudo cmake --install build

    popd > /dev/null
    rm -f "$archive"
    popd > /dev/null

    print_success "Taskwarrior built and installed from source!"
}

check_repo_version() {
    local pkg_manager=$(get_preferred_pkg_manager)
    local repo_version

    print_info "Checking repository version..."

    repo_version=$(get_repo_version "task" "$pkg_manager" || get_repo_version "taskwarrior" "$pkg_manager")

    if [ -z "$repo_version" ]; then
        print_warning "Could not determine repository version"
        return 1
    fi

    print_info "Repository version: $repo_version"

    if version_ge "$repo_version" "$MIN_REPO_VERSION"; then
        print_success "Repository version >= ${MIN_REPO_VERSION}, will install from repo"
        return 0
    else
        print_warning "Repository version < ${MIN_REPO_VERSION}, will build from source"
        return 1
    fi
}

main() {
    print_info "Starting Taskwarrior installation..."

    # Install Python dependencies
    install_python_dependencies

    # Check if taskwarrior is already installed
    if pkg_is_installed task; then
        print_success "Taskwarrior is already installed!"
        task --version
    else
        # Check repository version and decide installation method
        if check_repo_version; then
            if ! install_from_repo; then
                print_warning "Repository installation failed, building from source..."
                build_from_source
            fi
        else
            build_from_source
        fi

        # Verify installation
        if pkg_is_installed task; then
            print_success "Taskwarrior installed successfully!"
            task --version
        else
            print_error "Taskwarrior installation failed!"
            exit 1
        fi
    fi

    # Install taskwarrior-tui
    if ! command -v taskwarrior-tui &> /dev/null; then
        install_taskwarrior_tui
    else
        print_success "taskwarrior-tui is already installed"
    fi

    print_success "All components installed successfully!"
}

main "$@"
