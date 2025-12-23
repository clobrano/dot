# Makefile for managing dotfiles environment setup
# Run 'make help' for usage information

SHELL := /bin/bash
.PHONY: all help os-bootstrap neovim neovim-deps golang lsp lsp-python lsp-bash taskwarrior starship clean info

# Default target
all: info os-bootstrap neovim golang lsp taskwarrior starship
	@echo ""
	@echo "✓ All components installed successfully!"
	@echo ""
	@echo "Restart your shell to apply all changes."

help:
	@echo "Dotfiles Environment Setup - Makefile Targets"
	@echo ""
	@echo "Main targets:"
	@echo "  make all          - Install everything (OS bootstrap + all tools)"
	@echo "  make os-bootstrap - Bootstrap OS (Fedora or Kinoite)"
	@echo "  make dev          - Install development tools (neovim, golang, lsp)"
	@echo ""
	@echo "Individual tool targets:"
	@echo "  make neovim       - Install Neovim and its dependencies"
	@echo "  make golang       - Install Go language"
	@echo "  make lsp          - Install all Language Servers"
	@echo "  make taskwarrior  - Install Taskwarrior"
	@echo "  make starship     - Install Starship prompt"
	@echo ""
	@echo "LSP-specific targets:"
	@echo "  make lsp-python   - Install Python LSP only"
	@echo "  make lsp-bash     - Install Bash LSP only"
	@echo ""
	@echo "Utility targets:"
	@echo "  make info         - Show system information"
	@echo "  make clean        - Clean up temporary files"
	@echo "  make help         - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make os-bootstrap           # Just set up the OS"
	@echo "  make neovim golang          # Install specific tools"
	@echo "  make dev                    # Install dev environment"

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
