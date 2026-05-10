# Configuration Environment Setup

This directory contains scripts to bootstrap and configure your development environment across different operating systems.

## Quick Start

```bash
cd ~/.dot/.config/cconf

# Show available targets
make help

# Bootstrap your OS and install CLI tools (default)
make all

# Install CLI tools + GUI applications
make all-with-apps

# Or install specific components
make neovim golang lsp taskwarrior starship

# Install GUI applications separately (optional)
make flatpak-apps
```

## Directory Structure

```
.config/cconf/
├── Makefile              # Main orchestrator - run 'make help'
├── README.md             # This file
│
├── lib/                  # Shared utilities (don't run directly)
│   ├── detect.sh         # OS & package manager detection
│   ├── install.sh        # Package installation abstraction
│   └── utils.sh          # Helper functions (version checks, etc.)
│
├── os/                   # OS-specific bootstrapping
│   ├── fedora.sh         # Fedora workstation setup
│   ├── kinoite.sh        # Immutable OS (Kinoite/Silverblue) setup
│   └── rpmfusion.sh      # RPM Fusion & media codecs (optional)
│
├── environments/         # Tool-specific installers
│   ├── neovim/
│   │   ├── install.sh         # Neovim installer
│   │   └── dependencies.sh    # CLI tools (fzf, ripgrep, etc.)
│   ├── golang/
│   │   └── install.sh         # Go language installer
│   ├── lsp/
│   │   ├── python.sh          # Python LSP
│   │   └── bash.sh            # Bash LSP
│   ├── taskwarrior/
│   │   ├── install.sh         # Taskwarrior + TUI
│   │   └── taskwarrior.pdf    # Documentation
│   ├── starship/
│   │   └── install.sh         # Starship prompt
│   └── flatpak/
│       └── install.sh         # GUI apps (Chrome, Slack, etc.)
│
└── archive/              # Old scripts (not maintained)
    └── README.md         # Archive documentation
```

## Supported Operating Systems

### Fedora Workstation
- Uses DNF package manager
- RPM Fusion repositories (optional - `make rpmfusion`)
- Media codecs (optional - included with rpmfusion)
- Flatpak applications (optional - `make flatpak-apps`)

### Kinoite / Silverblue (Immutable OS)
- Homebrew for CLI tools
- Flatpak for GUI applications
- Toolbox/Distrobox for containerized environments
- Minimal rpm-ostree layering

## Makefile Targets

### Main Targets
- `make all` or `make all-cli` - Install CLI tools only (default)
- `make all-with-apps` - Install everything (CLI tools + GUI apps)
- `make os-bootstrap` - Bootstrap OS only
- `make dev` - Install development environment (neovim + golang + lsp)
- `make help` - Show all available targets

### CLI Tools
- `make neovim` - Neovim + dependencies
- `make golang` - Go programming language
- `make lsp` - All language servers
- `make lsp-python` - Python LSP only
- `make lsp-bash` - Bash LSP only
- `make taskwarrior` - Task management (version check logic)
- `make starship` - Shell prompt

### Optional Components (Fedora)
- `make rpmfusion` - Install RPM Fusion repositories & media codecs
- `make flatpak-apps` - Install Flatpak GUI apps (Chrome, Slack, Telegram, Obsidian, etc.)

### Utilities
- `make info` - Show system information
- `make clean` - Remove temporary files
- `make permissions` - Fix script permissions

## How It Works

### 1. OS Detection
The `lib/detect.sh` script automatically detects:
- Operating system (Fedora, Kinoite, etc.)
- Available package managers (dnf, brew, flatpak, etc.)
- OS variant (standard or immutable)

### 2. Package Manager Abstraction
The `lib/install.sh` script provides unified functions:
```bash
pkg_install <package>           # Install using preferred manager
pkg_install_bulk pkg1 pkg2 ...  # Install multiple packages
pkg_is_installed <command>      # Check if installed
```

### 3. Smart Installation
Each tool installer:
- Checks if already installed (idempotent)
- Tries package manager first
- Falls back to manual installation if needed
- Handles dependencies automatically

### 4. Taskwarrior Version Logic
- Checks repository version
- Installs from repo if version >= 3.x
- Builds from source otherwise
- Includes taskwarrior-tui and Python dependencies

## Manual Usage

You can also run scripts individually:

```bash
# Bootstrap Fedora
bash os/fedora.sh

# Install Neovim
bash environments/neovim/install.sh

# Install with options
BUILD_FROM_SOURCE=true bash environments/neovim/install.sh
INSTALL_GO_VERSION=1.22.0 bash environments/golang/install.sh
```

## Environment Variables

### Neovim
- `BUILD_FROM_SOURCE=true` - Force build from source

### Golang
- `INSTALL_GO_VERSION=1.22.0` - Specify Go version
- `INSTALL_METHOD=auto|package|tarball|gimme` - Installation method

### Taskwarrior
- `TASKWARRIOR_VERSION=3.3.0` - Taskwarrior version to build
- `TASKWARRIOR_TUI_VERSION=v0.26.3` - TUI version

## Key Features

### Cross-Platform Support
- Detects OS automatically
- Adapts to available package managers
- Works on both standard and immutable systems

### Idempotent
- Safe to run multiple times
- Checks before installing
- Skips already-installed components

### Dependencies
- Makefile handles dependency order
- Scripts can be run independently
- Clear dependency documentation

### Clean Separation
- OS setup vs tool installation
- Base packages vs tool-specific dependencies
- System-wide vs user-local installations

## Migration from Old Structure

Old scripts have been archived in `archive/`.

Key changes:
- Fedora scripts consolidated into `os/fedora.sh`
- Tool installers now OS-agnostic
- Neovim dependencies separated from base packages
- Removed: atuin, conserver-client
- Taskwarrior includes smart version checking

See `archive/README.md` for details on archived scripts.

## Troubleshooting

### Scripts not executable
```bash
make permissions
```

### Package manager not detected
```bash
make info  # Check detection
```

### Build failures
Check that dependencies are installed:
- Fedora: `cmake`, `gcc`, `git`, `curl`
- Build tools usually installed by OS bootstrap

### Immutable OS issues
Some tools may need to be installed in toolbox:
```bash
toolbox enter fedora-toolbox
cd ~/.dot/.config/cconf
make <target>
```

## Contributing

When adding new tools:
1. Create directory under `environments/`
2. Add `install.sh` using lib utilities
3. Add target to `Makefile`
4. Update this README

## License

These are personal configuration scripts. Use at your own risk.
