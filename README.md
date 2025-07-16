# Dotfiles Repository

This repository contains my personal dotfiles for configuring various tools on macOS. It sets up configurations for Neovim, Aerospace tiling window manager, ZSH, Oh My Posh, and Alacritty.

For my personal use. Reuse at your own risk.

## Contents

- **nvim/**: Neovim configuration files (symlinked to `~/.config/nvim`).
- **aerospace/**: Aerospace tiling window manager settings (symlinked to `~/.config/aerospace`).
- **.zshrc**: ZSH configuration file (symlinked to `~/.zshrc`).
- **zsh/**: Custom ZSH scripts and plugins (symlinked to `~/.config/zsh`).
- **ohmyposh/**: Oh My Posh theme and configuration (symlinked to `~/.config/ohmyposh`).
- **alacritty/**: Alacritty terminal theming and settings (symlinked to `~/.config/alacritty`).
- **install.sh**: Bash script to install all applications i use for development (this will also run init_symlinks.sh)
- **init_symlinks.sh**: Bash script to create symlinks and set up the configurations

## Prerequisites

- macOS (tested environment; may work on other Unix-like systems).
- Git installed to clone the repository.
- Homebrew (for installing dependencies like Gum: `brew install gum`).
- The tools being configured (e.g., Neovim, Aerospace, ZSH, Oh My Posh, Alacritty) should be installed separately.

## Installation

1. Clone the repository to your preferred location (e.g., `~/dotfiles`)
2. Make the install script executable: `chmod +x installer.sh`
3. Run the installer: `./install.sh`
- The script will check for `~/.config`, create symlinks, and back up existing configurations if needed.
- It prompts for confirmations using Gum.
4. Source your ZSH config if necessary: `source ~/.zshrc`

## Notes

- **Backups**: Existing configs are backed up to `~/.config.backup/` with timestamps before symlinking.
- **Updates**: To update, pull changes from the repo and re-run `install.sh` if needed.
- **Customization**: Edit files in the repo; symlinks ensure changes propagate.
- **Issues**: If symlinks fail (e.g., permissions), run with sudo or check paths.
- This setup assumes the script runs from the repo root.
