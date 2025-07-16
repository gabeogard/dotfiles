#!/bin/bash

if ! command -v gum &> /dev/null; then
    echo "Gum is required. Install with: brew install gum"
    exit 1
fi

REPO_ROOT=$(pwd)
CONFIG_DIR="$HOME/.config"
TARGET_DOTDIR="$REPO_ROOT"

gum style --foreground 212 --border double --padding "1 2" --margin "1" \
    "Dotfiles Installer: Dynamically symlinking packages to ~/.config"

gum log --level info "Checking $CONFIG_DIR..."
if [ ! -d "$CONFIG_DIR" ]; then
    gum spin --spinner dot --title "Creating $CONFIG_DIR..." -- sleep 1
    mkdir -p "$CONFIG_DIR"
    gum log --level info "$CONFIG_DIR created."
else
    gum log --level info "$CONFIG_DIR already exists."
fi

BACKUP_DIR="$HOME/.config.backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

gum log --level info "Discovering packages in $TARGET_DOTDIR..."
PACKAGES=()
for dir in "$TARGET_DOTDIR"/*/; do
    if [ -d "$dir" ]; then
        basename_dir=$(basename "$dir")
        if [ "$basename_dir" != ".git" ]; then
            PACKAGES=("${PACKAGES[@]}" "$basename_dir")
        fi
    fi
done

if [ ${#PACKAGES[@]} -eq 0 ]; then
    gum log --level error "No packages found in $TARGET_DOTDIR."
    exit 2
fi

gum log --level info "Found packages: ${PACKAGES[*]}"

for pkg in "${PACKAGES[@]}"; do
    SOURCE="$REPO_ROOT/$pkg"
    TARGET="$CONFIG_DIR/$pkg"
    
    gum log --level info "Checking $TARGET..."
    
    if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
        gum log --level info "$TARGET is already symlinked to repo; skipping."
        continue
    fi
    
    if [ -e "$TARGET" ]; then
        if gum confirm "Target $TARGET exists. Backup and replace with symlink?"; then
            gum spin --spinner dot --title "Backing up $TARGET..." -- mv "$TARGET" "$BACKUP_DIR/$pkg"
            gum log --level info "Backed up to $BACKUP_DIR/$pkg"
        else
            gum log --level warn "Skipping $TARGET."
            continue
        fi
    fi
    
    gum spin --spinner dot --title "Symlinking $SOURCE to $TARGET..." -- ln -s "$SOURCE" "$TARGET"
    gum log --level info "Symlinked $TARGET."
done

ZSHRC_SOURCE="$REPO_ROOT/.zshrc"
ZSHRC_TARGET="$HOME/.zshrc"
if [ -f "$ZSHRC_SOURCE" ]; then
    gum log --level info "Handling loose .zshrc (consider moving to zsh/ for auto-symlinking)..."
    if [ -L "$ZSHRC_TARGET" ] && [ "$(readlink "$ZSHRC_TARGET")" = "$ZSHRC_SOURCE" ]; then
        gum log --level info "$ZSHRC_TARGET already symlinked; skipping."
    else
        if [ -e "$ZSHRC_TARGET" ]; then
            if gum confirm "Target $ZSHRC_TARGET exists. Backup and symlink?"; then
                gum spin --spinner dot --title "Backing up $ZSHRC_TARGET..." -- mv "$ZSHRC_TARGET" "$BACKUP_DIR/.zshrc"
                gum log --level info "Backed up to $BACKUP_DIR/.zshrc"
            else
                gum log --level warn "Skipping $ZSHRC_TARGET."
            fi
        fi
        gum spin --spinner dot --title "Symlinking $ZSHRC_SOURCE to $ZSHRC_TARGET..." -- ln -s "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
        gum log --level info "Symlinked $ZSHRC_TARGET."
    fi
fi

TMUXCONF_SOURCE="$REPO_ROOT/.tmux.conf"
TMUXCONF_TARGET="$HOME/.tmux.conf"
if [ -f "$TMUXCONF_SOURCE" ]; then
    gum log --level info "Handling loose .tmux.conf (consider moving to tmux/ for auto-symlinking)..."
    if [ -L "$TMUXCONF_TARGET" ] && [ "$(readlink "$TMUXCONF_TARGET")" = "$TMUXCONF_SOURCE" ]; then
        gum log --level info "$TMUXCONF_TARGET already symlinked; skipping."
    else
        if [ -e "$TMUXCONF_TARGET" ]; then
            if gum confirm "Target $TMUXCONF_TARGET exists. Backup and symlink?"; then
                gum spin --spinner dot --title "Backing up $TMUXCONF_TARGET..." -- mv "$TMUXCONF_TARGET" "$BACKUP_DIR/.tmux.conf"
                gum log --level info "Backed up to $BACKUP_DIR/.tmux.conf"
            else
                gum log --level warn "Skipping $TMUXCONF_TARGET."
            fi
        fi
        gum spin --spinner dot --title "Symlinking $TMUXCONF_SOURCE to $TMUXCONF_TARGET..." -- ln -s "$TMUXCONF_SOURCE" "$TMUXCONF_TARGET"
        gum log --level info "Symlinked $TMUXCONF_TARGET."
    fi

    # Install TPM if not already present
    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$TPM_DIR" ]; then
        gum spin --spinner dot --title "Cloning tmux plugin manager (TPM)..." -- git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        gum log --level info "TPM cloned to $TPM_DIR."
    else
        gum log --level info "TPM already exists at $TPM_DIR; skipping clone."
    fi
fi

gum style --foreground 46 --border rounded --padding "1 2" --margin "1" \
    "Setup complete! Backups in $BACKUP_DIR if any. Run 'source ~/.zshrc' if needed. Add new dirs to repo for auto-symlinking."
