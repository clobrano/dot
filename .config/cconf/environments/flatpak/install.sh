#!/usr/bin/env bash
# Flatpak GUI applications installer
# Installs common desktop applications via Flatpak

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/utils.sh"

ensure_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        print_error "Flatpak not found!"
        print_info "Install it first:"
        print_info "  Fedora: sudo dnf install flatpak"
        print_info "  Kinoite: Already installed"
        exit 1
    fi

    # Add Flathub repository if not exists
    if ! flatpak remotes | grep -q flathub; then
        print_info "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        print_success "Flathub repository added"
    else
        print_info "Flathub repository already configured"
    fi
}

# GUI Applications to install
FLATPAK_APPS=(
    # System utilities
    "com.github.tchx84.Flatseal"              # Flatpak permissions manager

    # Terminal emulators
    "org.wezfurlong.wezterm"                  # WezTerm terminal

    # Web browsers
    "com.google.Chrome"                       # Google Chrome

    # Cloud storage & sync
    "com.dropbox.Client"                      # Dropbox
    "com.github.zocker_160.SyncThingy"        # Syncthing GUI

    # Productivity
    "md.obsidian.Obsidian"                    # Obsidian notes

    # Communication
    "org.telegram.desktop"                    # Telegram
    "com.slack.Slack"                         # Slack
)

install_flatpak_apps() {
    print_info "Installing ${#FLATPAK_APPS[@]} Flatpak applications..."
    echo ""

    for app in "${FLATPAK_APPS[@]}"; do
        # Skip comments
        [[ "$app" =~ ^#.*$ ]] && continue

        # Check if already installed
        if flatpak list --app | grep -q "$app"; then
            print_success "$app already installed"
        else
            print_info "Installing $app..."
            if flatpak install -y flathub "$app"; then
                print_success "$app installed"
            else
                print_error "Failed to install $app"
            fi
        fi
    done
}

main() {
    print_info "Starting Flatpak applications installation..."
    echo ""

    print_warning "This will install GUI desktop applications via Flatpak."
    print_info "Applications to install:"
    for app in "${FLATPAK_APPS[@]}"; do
        echo "  - $app"
    done
    echo ""

    read -p "Continue? (y/N) " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi

    ensure_flatpak
    install_flatpak_apps

    echo ""
    print_success "Flatpak applications installed successfully!"
    print_info "Launch apps from your application menu or with: flatpak run <app-id>"
}

main "$@"
