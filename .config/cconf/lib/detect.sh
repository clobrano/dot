#!/bin/bash
# OS and package manager detection

# Detect operating system
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID="$ID"
        OS_VERSION="$VERSION_ID"
        OS_NAME="$NAME"

        # Check if it's an immutable OS variant
        if [[ "$VARIANT_ID" == "kinoite" ]] || [[ "$VARIANT_ID" == "silverblue" ]]; then
            OS_VARIANT="immutable"
        else
            OS_VARIANT="standard"
        fi
    else
        OS_ID="unknown"
        OS_VARIANT="unknown"
    fi

    export OS_ID OS_VERSION OS_NAME OS_VARIANT
}

# Detect available package managers
detect_package_managers() {
    PKG_MANAGERS=()

    # Check for DNF
    if command -v dnf &> /dev/null; then
        PKG_MANAGERS+=("dnf")
    fi

    # Check for Homebrew
    if command -v brew &> /dev/null; then
        PKG_MANAGERS+=("brew")
    fi

    # Check for Flatpak
    if command -v flatpak &> /dev/null; then
        PKG_MANAGERS+=("flatpak")
    fi

    # Check for toolbox/distrobox
    if command -v toolbox &> /dev/null; then
        PKG_MANAGERS+=("toolbox")
    fi

    if command -v distrobox &> /dev/null; then
        PKG_MANAGERS+=("distrobox")
    fi

    # Check for APT
    if command -v apt &> /dev/null; then
        PKG_MANAGERS+=("apt")
    fi

    export PKG_MANAGERS
}

# Get preferred package manager based on OS
get_preferred_pkg_manager() {
    detect_os
    detect_package_managers

    # For immutable OS, prefer brew or flatpak
    if [ "$OS_VARIANT" = "immutable" ]; then
        if [[ " ${PKG_MANAGERS[@]} " =~ " brew " ]]; then
            echo "brew"
        elif [[ " ${PKG_MANAGERS[@]} " =~ " flatpak " ]]; then
            echo "flatpak"
        elif [[ " ${PKG_MANAGERS[@]} " =~ " toolbox " ]]; then
            echo "toolbox"
        elif [[ " ${PKG_MANAGERS[@]} " =~ " distrobox " ]]; then
            echo "distrobox"
        else
            echo "none"
        fi
    # For standard Fedora, prefer DNF
    elif [ "$OS_ID" = "fedora" ]; then
        if [[ " ${PKG_MANAGERS[@]} " =~ " dnf " ]]; then
            echo "dnf"
        else
            echo "none"
        fi
    # For Debian/Ubuntu, prefer APT
    elif [[ "$OS_ID" =~ (debian|ubuntu) ]]; then
        if [[ " ${PKG_MANAGERS[@]} " =~ " apt " ]]; then
            echo "apt"
        else
            echo "none"
        fi
    else
        echo "none"
    fi
}

# Print detection info
print_detection_info() {
    detect_os
    detect_package_managers

    echo "OS: $OS_NAME ($OS_ID)"
    echo "Version: $OS_VERSION"
    echo "Variant: $OS_VARIANT"
    echo "Available package managers: ${PKG_MANAGERS[*]}"
    echo "Preferred: $(get_preferred_pkg_manager)"
}

# If sourced, just export functions
# If executed directly, print info
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    print_detection_info
fi
