#!/usr/bin/env bash
# Python LSP installer - OS-agnostic
# Installs python-lsp-server with all optional dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(cd "$SCRIPT_DIR/../../lib" && pwd)"

source "$LIB_DIR/utils.sh"

print_info "Installing Python Language Server..."

if ! command -v pip3 &> /dev/null; then
    print_error "pip3 not found! Please install Python 3 and pip first."
    exit 1
fi

# Install python-lsp-server with all optional dependencies
pip3 install --user 'python-lsp-server[all]'

print_success "Python Language Server installed successfully!"

# Verify installation
if command -v pylsp &> /dev/null; then
    print_success "pylsp command is available"
else
    print_warning "pylsp not found in PATH. You may need to add ~/.local/bin to your PATH"
fi
