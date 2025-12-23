# Makefile for managing dotfiles environment setup
# Run 'make help' for usage information

SHELL := /bin/bash
.PHONY: all all-cli all-with-apps help os-bootstrap rpmfusion neovim neovim-deps golang lsp lsp-python lsp-bash taskwarrior starship flatpak-apps clean info

# Default target - CLI tools only
all: all-cli

# CLI tools only (no GUI apps)
all-cli: info os-bootstrap neovim golang lsp taskwarrior starship
	@echo ""
	@echo "✓ All CLI tools installed successfully!"
	@echo ""
	@echo "Optional components:"
	@echo "  - RPM Fusion & media codecs: make rpmfusion"
	@echo "  - GUI applications: make flatpak-apps"
	@echo ""
	@echo "Restart your shell to apply all changes."

# Everything including Flatpak GUI apps
all-with-apps: all-cli flatpak-apps
	@echo ""
	@echo "✓ All components including GUI apps installed!"
	@echo ""
	@echo "Restart your shell to apply all changes."

help:
	@echo "Dotfiles Environment Setup - Makefile Targets"
	@echo ""
	@echo "Main targets:"
	@echo "  make all             - Install CLI tools only (default)"
	@echo "  make all-cli         - Install CLI tools only (explicit)"
	@echo "  make all-with-apps   - Install everything (CLI tools + GUI apps)"
	@echo "  make os-bootstrap    - Bootstrap OS (Fedora or Kinoite)"
	@echo "  make dev             - Install development tools (neovim, golang, lsp)"
	@echo ""
	@echo "CLI tool targets:"
	@echo "  make neovim          - Install Neovim and its dependencies"
	@echo "  make golang          - Install Go language"
	@echo "  make lsp             - Install all Language Servers"
	@echo "  make taskwarrior     - Install Taskwarrior"
	@echo "  make starship        - Install Starship prompt"
	@echo ""
	@echo "Optional components (Fedora only):"
	@echo "  make rpmfusion       - Install RPM Fusion repos & media codecs"
	@echo "  make flatpak-apps    - Install Flatpak GUI apps (Chrome, Slack, etc.)"
	@echo ""
	@echo "LSP-specific targets:"
	@echo "  make lsp-python      - Install Python LSP only"
	@echo "  make lsp-bash        - Install Bash LSP only"
	@echo ""
	@echo "Utility targets:"
	@echo "  make info            - Show system information"
	@echo "  make clean           - Clean up temporary files"
	@echo "  make help            - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make all                    # CLI tools only"
	@echo "  make all-with-apps          # Everything including GUI apps"
	@echo "  make os-bootstrap           # Just set up the OS"
	@echo "  make neovim golang          # Install specific tools"
	@echo "  make dev                    # Install dev environment"
	@echo "  make rpmfusion              # Install RPM Fusion & codecs (Fedora)"
	@echo "  make flatpak-apps           # Install GUI apps only"

info:
	@echo "=== System Information ==="
	@bash lib/detect.sh

# OS Bootstrap - Automatically detect and run the appropriate OS script
os-bootstrap:
	@echo "=== OS Bootstrap ==="
	@if [ -f /etc/os-release ]; then \
		. /etc/os-release; \
		if [ "$$VARIANT_ID" = "kinoite" ] || [ "$$VARIANT_ID" = "silverblue" ]; then \
			echo "Detected immutable OS ($$VARIANT_ID), running kinoite.sh..."; \
			bash os/kinoite.sh; \
		elif [ "$$ID" = "fedora" ]; then \
			echo "Detected Fedora, running fedora.sh..."; \
			bash os/fedora.sh; \
		else \
			echo "Unsupported OS: $$ID"; \
			echo "Please run the appropriate script manually from os/ directory"; \
			exit 1; \
		fi \
	else \
		echo "Cannot detect OS. Please run the appropriate script from os/ directory"; \
		exit 1; \
	fi

# RPM Fusion repositories and media codecs (Fedora only)
rpmfusion:
	@echo "=== Installing RPM Fusion & Media Codecs ==="
	@bash os/rpmfusion.sh

# Neovim and dependencies
neovim-deps:
	@echo "=== Installing Neovim Dependencies ==="
	@bash environments/neovim/dependencies.sh

neovim: neovim-deps
	@echo "=== Installing Neovim ==="
	@bash environments/neovim/install.sh

# Golang
golang:
	@echo "=== Installing Go ==="
	@bash environments/golang/install.sh

# Language Servers (depends on neovim)
lsp-python:
	@echo "=== Installing Python LSP ==="
	@bash environments/lsp/python.sh

lsp-bash:
	@echo "=== Installing Bash LSP ==="
	@bash environments/lsp/bash.sh

lsp: neovim lsp-python lsp-bash
	@echo "✓ All Language Servers installed"

# Taskwarrior
taskwarrior:
	@echo "=== Installing Taskwarrior ==="
	@bash environments/taskwarrior/install.sh

# Starship prompt
starship:
	@echo "=== Installing Starship ==="
	@bash environments/starship/install.sh

# Flatpak GUI applications
flatpak-apps:
	@echo "=== Installing Flatpak GUI Applications ==="
	@bash environments/flatpak/install.sh

# Development environment (common dev tools)
dev: neovim golang lsp
	@echo "✓ Development environment installed"

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	@find . -name "*.tar.gz" -type f -delete
	@find . -name "*.zip" -type f -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✓ Cleanup complete"

# Make all scripts executable
permissions:
	@echo "Setting executable permissions on all scripts..."
	@find lib os environments -name "*.sh" -type f -exec chmod +x {} \;
	@echo "✓ Permissions set"
