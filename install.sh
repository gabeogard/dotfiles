#!/usr/bin/env bash

if ! command -v gum &> /dev/null; then
    echo "Gum is required. Install with: brew install gum"
    exit 1
fi

gum style --foreground 212 --border double --padding "1 2" --margin "1" \
    "macOS Tool Installer: Installing selected applications via Homebrew"

# Function to check and update zsh if outdated
check_zsh_up_to_date() {
    local zsh_version_homebrew
    local installed_zsh_version
    installed_zsh_version=$(zsh --version | grep -o -E '[0-9.]+' | head -n 1)
    zsh_version_homebrew=$(brew info zsh | head -n 1 | grep -o -E '[0-9.]+')

    if [[ "$zsh_version_homebrew" != "$installed_zsh_version" ]]; then
        gum log --level warn "Pre-installed zsh version=${installed_zsh_version} is out of date. Homebrew provides version=${zsh_version_homebrew}"
        if gum confirm "Would you like to install the latest zsh via Homebrew?"; then
            gum spin --spinner dot --title "Installing zsh..." -- brew install --formula zsh
            gum log --level info "zsh installed/updated."
        else
            gum log --level warn "Skipping zsh update."
        fi
    else
        gum log --level info "zsh is up to date. Skipping..."
    fi
}

# Install oh-my-posh
install_oh_my_posh() {
    if brew ls oh-my-posh &>/dev/null; then
        gum log --level info "oh-my-posh already installed. Skipping..."
    else
        gum log --level info "oh-my-posh: Prompt renderer for zsh."
        if gum confirm "Would you like to install oh-my-posh?"; then
            gum spin --spinner dot --title "Installing oh-my-posh..." -- brew install --formula oh-my-posh
            gum log --level info "oh-my-posh installed."

            gum log --level info "oh-my-posh requires a Nerd Font for icons."
            if gum confirm "Would you like to install 'font-meslo-lg-nerd-font'?"; then
                gum spin --spinner dot --title "Installing font-meslo-lg-nerd-font..." -- brew install --cask font-meslo-lg-nerd-font
                gum log --level info "Font installed."
            else
                gum log --level warn "Skipping font installation. Icons may not render correctly."
            fi
        else
            gum log --level warn "Skipping oh-my-posh installation."
        fi
    fi
}

# Install neovim
install_neovim() {
    if brew ls neovim &>/dev/null; then
        gum log --level info "neovim already installed. Skipping..."
    else
        gum log --level info "neovim: Vim-fork focused on extensibility and usability."
        if gum confirm "Would you like to install neovim?"; then
            gum spin --spinner dot --title "Installing neovim..." -- brew install --formula neovim
            gum log --level info "neovim installed."
        else
            gum log --level warn "Skipping neovim installation."
        fi
    fi
}

# Install tmux
install_tmux() {
    if brew ls tmux &>/dev/null; then
        gum log --level info "tmux already installed. Skipping..."
    else
        gum log --level info "tmux: The most popular terminal multiplexer."
        if gum confirm "Would you like to install tmux?"; then
            gum spin --spinner dot --title "Installing tmux..." -- brew install --formula tmux
            gum log --level info "tmux installed."
        else
            gum log --level warn "Skipping tmux installation."
        fi
    fi
}

# Install Alacritty
install_alacritty() {
    if brew ls alacritty &>/dev/null; then
        gum log --level info "Alacritty already installed. Skipping..."
    else
        gum log --level info "Alacritty: A fast, cross-platform, OpenGL terminal emulator."
        if gum confirm "Would you like to install Alacritty?"; then
            gum spin --spinner dot --title "Installing Alacritty..." -- brew install --cask alacritty
            gum log --level info "Alacritty installed."
        else
            gum log --level warn "Skipping Alacritty installation."
        fi
    fi
}

# Install Aerospace (includes JankyBorders for borders)
install_aerospace() {
    if brew ls aerospace &>/dev/null; then
        gum log --level info "AeroSpace already installed. Skipping..."
    else
        gum log --level info "AeroSpace: Tiling window manager for macOS. Includes JankyBorders for active window borders."
        gum log --level info "See: https://github.com/nikitabobko/AeroSpace and https://github.com/FelixKratz/JankyBorders"
        if gum confirm "Would you like to install AeroSpace and JankyBorders?"; then
            gum spin --spinner dot --title "Tapping repositories..." -- bash -c 'brew tap nikitabobko/tap && brew tap FelixKratz/formulae'
            gum spin --spinner dot --title "Installing AeroSpace..." -- brew install --cask nikitabobko/tap/aerospace
            gum spin --spinner dot --title "Installing JankyBorders..." -- brew install FelixKratz/formulae/borders
            gum log --level info "AeroSpace and JankyBorders installed."
        else
            gum log --level warn "Skipping AeroSpace installation."
        fi
    fi
}

# Run installations
check_zsh_up_to_date
install_oh_my_posh
install_neovim
install_tmux
install_alacritty
install_aerospace

# Run the symlink initialization script
gum style --foreground 212 --border double --padding "1 2" --margin "1" \
    "Now initializing symlinks..."
bash init_symlinks.sh

gum style --foreground 46 --border rounded --padding "1 2" --margin "1" \
    "Installation and setup complete! Remember to configure your tools as needed."
