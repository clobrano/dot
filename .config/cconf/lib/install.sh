#!/bin/bash
# Package installation abstraction layer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/detect.sh"

# Install package using the appropriate package manager
# Usage: pkg_install <package_name> [package_manager]
pkg_install() {
    local package="$1"
    local pkg_manager="${2:-$(get_preferred_pkg_manager)}"

    if [ -z "$package" ]; then
        echo "Error: No package name provided"
        return 1
    fi

    echo "Installing $package using $pkg_manager..."

    case "$pkg_manager" in
        dnf)
            sudo dnf install -y "$package"
            ;;
        brew)
            brew install "$package"
            ;;
        flatpak)
            flatpak install -y "$package"
            ;;
        toolbox)
            toolbox run sudo dnf install -y "$package"
            ;;
        distrobox)
            distrobox enter fedora -- sudo dnf install -y "$package"
            ;;
        apt)
            sudo apt install -y "$package"
            ;;
        none)
            echo "Error: No package manager available"
            return 1
            ;;
        *)
            echo "Error: Unknown package manager: $pkg_manager"
            return 1
            ;;
    esac
}

# Install multiple packages at once
# Usage: pkg_install_bulk [package_manager] package1 package2 ...
pkg_install_bulk() {
    local pkg_manager="$1"
    shift
    local packages=("$@")

    if [ ${#packages[@]} -eq 0 ]; then
        echo "Error: No packages provided"
        return 1
    fi

    # If first arg is not a known package manager, treat it as a package
    if [[ ! "$pkg_manager" =~ ^(dnf|brew|flatpak|toolbox|distrobox|apt)$ ]]; then
        packages=("$pkg_manager" "${packages[@]}")
        pkg_manager=$(get_preferred_pkg_manager)
    fi

    echo "Installing ${#packages[@]} packages using $pkg_manager..."

    case "$pkg_manager" in
        dnf)
            sudo dnf install -y "${packages[@]}"
            ;;
        brew)
            brew install "${packages[@]}"
            ;;
        flatpak)
            for pkg in "${packages[@]}"; do
                flatpak install -y "$pkg"
            done
            ;;
        toolbox)
            toolbox run sudo dnf install -y "${packages[@]}"
            ;;
        distrobox)
            distrobox enter fedora -- sudo dnf install -y "${packages[@]}"
            ;;
        apt)
            sudo apt install -y "${packages[@]}"
            ;;
        *)
            echo "Error: Unknown package manager: $pkg_manager"
            return 1
            ;;
    esac
}

# Check if package is installed
# Usage: pkg_is_installed <command_name>
pkg_is_installed() {
    command -v "$1" &> /dev/null
}

# Install only if not already installed (idempotent)
# Usage: pkg_install_if_missing <command_name> <package_name> [package_manager]
pkg_install_if_missing() {
    local command="$1"
    local package="${2:-$1}"
    local pkg_manager="${3:-$(get_preferred_pkg_manager)}"

    if pkg_is_installed "$command"; then
        echo "$command is already installed, skipping..."
        return 0
    else
        pkg_install "$package" "$pkg_manager"
    fi
}
