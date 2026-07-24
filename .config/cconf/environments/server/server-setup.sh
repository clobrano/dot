#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REMOTE_DIR=".config/cconf/server"

usage() {
    echo "Usage: $(basename "$0") <ssh-host>"
    echo "  Copies server config files and installs dependencies on a remote machine."
    exit 1
}

[ $# -lt 1 ] && usage
HOST="$1"

echo "==> Copying config files to $HOST:~/$REMOTE_DIR/"
ssh "$HOST" "mkdir -p ~/$REMOTE_DIR"
scp "$SCRIPT_DIR/server-bashrc" "$SCRIPT_DIR/server-tmux.conf" "$HOST:~/$REMOTE_DIR/"

echo "==> Running remote setup on $HOST"
ssh "$HOST" bash -s "$REMOTE_DIR" <<'REMOTE_SCRIPT'
set -uo pipefail
REMOTE_DIR="$1"

# Deploy config files first — this must not fail
# Source server-bashrc from ~/.bashrc
SERVER_BASHRC="$HOME/$REMOTE_DIR/server-bashrc"
if ! grep -qF "$SERVER_BASHRC" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "# Custom server config" >> "$HOME/.bashrc"
    echo "[[ -f \"$SERVER_BASHRC\" ]] && source \"$SERVER_BASHRC\"" >> "$HOME/.bashrc"
    echo "Appended source line to ~/.bashrc"
else
    echo "~/.bashrc already sources server-bashrc"
fi

# Deploy tmux config
ln -sf "$HOME/$REMOTE_DIR/server-tmux.conf" "$HOME/.tmux.conf"
echo "Linked server-tmux.conf -> ~/.tmux.conf"

# Install packages (best-effort, won't block config deployment)
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

if command -v dnf &>/dev/null; then
    PM="dnf"
    PACKAGES=(tmux zsh neovim fzf the_silver_searcher)
elif command -v apt-get &>/dev/null; then
    PM="apt-get"
    PACKAGES=(tmux zsh neovim fzf silversearcher-ag)
elif command -v pacman &>/dev/null; then
    PM="pacman"
    PACKAGES=(tmux zsh neovim fzf the_silver_searcher)
else
    echo "WARNING: Unsupported package manager. Install manually: tmux zsh neovim fzf ag"
    PM=""
fi

if [ -n "$PM" ]; then
    for pkg in "${PACKAGES[@]}"; do
        echo "Installing $pkg..."
        $SUDO $PM install -y "$pkg" || echo "WARNING: failed to install $pkg"
    done
fi

echo ""
echo "Done. Run: source ~/.bashrc"
REMOTE_SCRIPT
