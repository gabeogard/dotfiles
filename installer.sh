#!/bin/bash
if ! command -v gum &> /dev/null; then
    echo "Gum is required. Install with: brew install gum"
    exit 1
fi

REPO_ROOT=$(pwd)

gum style --foreground 212 --border double --padding "1 2" --margin "1" \
    "Dotfiles Installer: Setting up symlinks in ~/.config"

gum log --level info "Checking ~/.config..."
if [ ! -d "$HOME/.config" ]; then
    gum spin --spinner dot --title "Creating ~/.config..." -- sleep 1
    mkdir -p "$HOME/.config"
    gum log --level info "~/.config created."
else
    gum log --level info "~/.config already exists."
fi

BACKUP_DIR="$HOME/.config.backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

DIRS=("nvim" "aerospace" "zsh" "ohmyposh" "alacritty")

for dir in "${DIRS[@]}"; do
    SOURCE="$REPO_ROOT/$dir"
    TARGET="$HOME/.config/$dir"
    
    if [ ! -d "$SOURCE" ]; then
        gum log --level error "Source $SOURCE does not exist; skipping."
        continue
    fi
    
    gum log --level info "Checking $TARGET..."
    
    if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
        gum log --level info "$TARGET is already symlinked to repo; skipping."
        continue
    fi
    
    if [ -e "$TARGET" ]; then
        if gum confirm "Target $TARGET exists. Backup and replace with symlink?"; then
            gum spin --spinner dot --title "Backing up $TARGET..." -- mv "$TARGET" "$BACKUP_DIR/$(basename "$TARGET")"
            gum log --level info "Backed up to $BACKUP_DIR/$(basename "$TARGET")"
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

if [ ! -f "$ZSHRC_SOURCE" ]; then
    gum log --level error "Source $ZSHRC_SOURCE does not exist; skipping."
else
    gum log --level info "Checking $ZSHRC_TARGET..."
    
    if [ -L "$ZSHRC_TARGET" ] && [ "$(readlink "$ZSHRC_TARGET")" = "$ZSHRC_SOURCE" ]; then
        gum log --level info "$ZSHRC_TARGET is already symlinked to repo; skipping."
    else
        if [ -e "$ZSHRC_TARGET" ]; then
            if gum confirm "Target $ZSHRC_TARGET exists. Backup and replace with symlink?"; then
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

gum style --foreground 46 --border rounded --padding "1 2" --margin "1" \
    "Setup complete! Backups in $BACKUP_DIR if any. Run 'source ~/.zshrc' if needed."
