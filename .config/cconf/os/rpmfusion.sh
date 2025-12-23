#!/usr/bin/env bash
# RPM Fusion repositories and media codecs installer
# Optional component for Fedora - adds non-free repos and multimedia codecs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../lib" && pwd)"

source "$LIB_DIR/detect.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/utils.sh"

enable_rpm_fusion() {
    print_info "Enabling RPM Fusion repositories..."

    # Check if RPM Fusion is already installed
    if rpm -q rpmfusion-free-release &> /dev/null; then
        print_success "RPM Fusion already enabled"
        return 0
    fi

    local fedora_version=$(rpm -E %fedora)

    print_info "Installing RPM Fusion Free..."
    sudo dnf install -y --skip-unavailable \
        "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm"

    print_info "Installing RPM Fusion Nonfree..."
    sudo dnf install -y --skip-unavailable \
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"

    print_info "Updating core group..."
    sudo dnf group update core -y --skip-unavailable

    print_success "RPM Fusion enabled"
}

install_media_codecs() {
    print_info "Installing multimedia codecs..."

    print_info "Installing GStreamer plugins..."
    sudo dnf install -y --skip-unavailable \
        gstreamer1-plugins-{bad-\*,good-\*,base} \
        gstreamer1-plugin-openh264 \
        gstreamer1-libav \
        --exclude=gstreamer1-plugins-bad-free-devel

    print_info "Installing LAME..."
    sudo dnf install -y --skip-unavailable lame\* --exclude=lame-devel

    print_info "Upgrading multimedia groups..."
    sudo dnf group upgrade --with-optional Multimedia -y --skip-unavailable
    sudo dnf group update multimedia sound-and-video -y --skip-unavailable

    print_success "Media codecs installed"
}

main() {
    print_info "Starting RPM Fusion and media codecs installation..."

    # Verify we're on Fedora
    detect_os
    if [ "$OS_ID" != "fedora" ]; then
        print_error "This script is for Fedora only! Detected OS: $OS_ID"
        exit 1
    fi

    echo ""
    print_warning "This will install RPM Fusion repositories (free and nonfree)"
    print_info "RPM Fusion provides:"
    echo "  - Multimedia codecs (H.264, MP3, etc.)"
    echo "  - Additional software not in official Fedora repos"
    echo "  - Non-free software components"
    echo ""
    read -p "Continue? (y/N) " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi

    # Step 1: Enable RPM Fusion repositories
    enable_rpm_fusion

    # Step 2: Install media codecs
    install_media_codecs

    echo ""
    print_success "RPM Fusion and media codecs installed successfully!"
    print_info "You can now play most multimedia formats"
}

main "$@"
