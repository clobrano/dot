#!/bin/bash
# Utility functions

# Compare version numbers
# Returns: 0 if v1 == v2, 1 if v1 > v2, 2 if v1 < v2
# Usage: version_compare "1.2.3" "1.2.4"
version_compare() {
    if [ "$1" = "$2" ]; then
        return 0
    fi

    local IFS=.
    local i ver1=($1) ver2=($2)

    # Fill empty positions with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done

    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

# Check if version is greater than or equal to target
# Usage: version_ge "1.2.3" "1.2.0" && echo "yes"
version_ge() {
    version_compare "$1" "$2"
    local result=$?
    [ $result -eq 0 ] || [ $result -eq 1 ]
}

# Check if version is greater than target
# Usage: version_gt "1.2.3" "1.2.0" && echo "yes"
version_gt() {
    version_compare "$1" "$2"
    [ $? -eq 1 ]
}

# Get version of a package from repository
# Usage: get_repo_version "taskwarrior" "dnf"
get_repo_version() {
    local package="$1"
    local pkg_manager="${2:-$(get_preferred_pkg_manager)}"

    case "$pkg_manager" in
        dnf)
            dnf info "$package" 2>/dev/null | grep -i "^Version" | awk '{print $3}' | head -1
            ;;
        brew)
            brew info "$package" 2>/dev/null | head -1 | awk '{print $3}'
            ;;
        apt)
            apt-cache show "$package" 2>/dev/null | grep "^Version:" | awk '{print $2}' | head -1
            ;;
        *)
            echo ""
            ;;
    esac
}

# Download file with progress
# Usage: download_file <url> <destination>
download_file() {
    local url="$1"
    local dest="$2"

    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$dest"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$dest"
    else
        echo "Error: Neither curl nor wget is available"
        return 1
    fi
}

# Extract archive
# Usage: extract_archive <file> [destination]
extract_archive() {
    local file="$1"
    local dest="${2:-.}"

    if [ ! -f "$file" ]; then
        echo "Error: File not found: $file"
        return 1
    fi

    case "$file" in
        *.tar.gz|*.tgz)
            tar -xzf "$file" -C "$dest"
            ;;
        *.tar.xz)
            tar -xJf "$file" -C "$dest"
            ;;
        *.tar.bz2)
            tar -xjf "$file" -C "$dest"
            ;;
        *.zip)
            unzip -q "$file" -d "$dest"
            ;;
        *)
            echo "Error: Unknown archive format: $file"
            return 1
            ;;
    esac
}

# Print colored output
# Usage: print_color "red" "Error message"
print_color() {
    local color="$1"
    local message="$2"

    case "$color" in
        red)     echo -e "\033[0;31m$message\033[0m" ;;
        green)   echo -e "\033[0;32m$message\033[0m" ;;
        yellow)  echo -e "\033[0;33m$message\033[0m" ;;
        blue)    echo -e "\033[0;34m$message\033[0m" ;;
        *)       echo "$message" ;;
    esac
}

# Print success message
print_success() {
    print_color "green" "✓ $1"
}

# Print error message
print_error() {
    print_color "red" "✗ $1"
}

# Print info message
print_info() {
    print_color "blue" "ℹ $1"
}

# Print warning message
print_warning() {
    print_color "yellow" "⚠ $1"
}
