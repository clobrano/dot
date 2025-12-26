# Installation Procedure

This section outlines the suggested procedure for setting up the dotfiles. It is crucial to follow the order to prevent conflicts with default configuration files created by various package installations.

### 1. Install Core Dependencies (`git` and `stow`)

Ensure you have `git` and `stow` installed. These are essential for managing the dotfiles repository. For Fedora-based systems, you can use `dnf`:

```sh
sudo dnf install git stow
```

### 2. Clone the Repository

Clone the dotfiles repository into your home directory. It's recommended to clone it into a hidden directory like `~/.dot`:

```sh
git clone https://github.com/clobrano/dot ~/.dot
```

### 3. Link Dotfiles with GNU Stow (Crucial Step)

**Before installing most applications**, navigate into the cloned repository and use `stow` to create symbolic links from the repository to your home directory (`~`). This step is critical because it ensures your custom configurations are symlinked *before* applications create their default configuration files, avoiding potential conflicts.

```sh
cd ~/.dot
stow .
```

**Note on `mybashrc`:** The `mybashrc` file is designed to be sourced explicitly from your existing `~/.bashrc` to avoid overwriting it. Add the following line to your `~/.bashrc`:

```sh
echo "source ~/.dot/mybashrc" >> ~/.bashrc
```

### 4. Install Dependencies and Tools

The project contains several install scripts under `.config/cconf/` directory and a `.config/cconf/Makefile` that orchestrates them, see `make help` for more information.

---

# Project Overview: Dotfiles Repository

This directory serves as a personal dotfiles repository, managed primarily using `GNU Stow`. It contains a comprehensive collection of configuration files for various applications and system settings, aimed at maintaining a consistent and personalized development environment across different machines.

The repository's structure is designed to be `stow`-friendly, allowing individual configuration sets (e.g., `.config/alacritty`, `.vimrc`) to be symlinked into the home directory.

## Key Files and Directories

*   `README.md`: Provides essential instructions for cloning the repository, installing dependencies (`git`, `stow`), and linking the dotfiles to the home directory.
*   `.gitconfig`: Global Git configuration settings.
*   `.zshrc`, `mybashrc`: Shell configuration files for Zsh and Bash, respectively. `mybashrc` is intended to be sourced from `~/.bashrc`.
*   `.vimrc`, `.config/nvim/`: Configuration files for Vim and Neovim, including plugins and custom settings.
*   `.tmux.conf`: Configuration for the Tmux terminal multiplexer.
*   `.wezterm.lua`: Configuration for the WezTerm terminal emulator.
*   `.config/alacritty/`: Configuration files for the Alacritty GPU-accelerated terminal emulator, including color themes.
*   `.config/hypr/`: Configuration files for the Hyprland Wayland compositor, including scripts for managing windows and applications.
*   `.config/waybar/`: Configuration for Waybar, a highly customizable Wayland bar.
*   `.config/rofi/`: Configuration for Rofi, a window switcher, application launcher, and dmenu replacement.
*   `.config/dunst/`: Configuration for Dunst, a highly customizable and lightweight notification daemon.
*   `.config/cconf/`: A crucial custom directory containing aliases, environment setups, and scripts for various tools and workflows. This directory centralizes many custom functions and installations.
    *   `cconf/aliases/`: Custom shell aliases for various commands (e.g., `apt`, `git`, `tmux`, `vim`, `dotfiles`).
    *   `cconf/environments/`: Scripts for setting up development environments, installing tools (e.g., `atuin`, `docker`, `flutter`, `pyenv`, `rust`), and configuring specific applications (e.g., `neovim`, `kubernetes`).
    *   `cconf/dot/dotfiles.sh`: Likely a script related to managing the dotfiles themselves.
    *   `cconf/fonts/install-fonts.sh`: Script for installing custom fonts.
*   `.inputrc`: Configuration for Readline, affecting command-line editing.
*   `.stow-local-ignore`: Specifies files to be ignored by `stow` during the linking process.
*   `.taskrc`, `.taskworkrc`, `taskwarrior-customization`: Configuration and custom settings for Taskwarrior, a command-line task manager.

## Usage

The primary method for deploying these dotfiles is by using `GNU Stow`. After cloning the repository into `~/.dot`, the user can navigate to `~/.dot` and run `stow .` to create symbolic links from the repository to the home directory (`~`).

**Important notes for usage:**

*   `stow .` will link most configurations.
*   The `mybashrc` file is intended to be sourced explicitly from the user's `~/.bashrc` to avoid overwriting it and to integrate custom Bash settings.
*   The `cconf` directory plays a central role in customizing the environment, providing aliases, and automating software installations and configurations.
