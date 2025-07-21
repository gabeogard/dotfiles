#!/bin/bash

if ! command -v stow &> /dev/null; then
    echo "GNU Stow is required. Install with: brew install stow"
    exit 1
fi

REPO_ROOT=$(pwd)
BACKUP_DIR="$HOME/.dotfiles.backup/$(date +%Y%m%d_%H%M%S)"

echo "Dotfiles Installer: Using GNU Stow for symlinks"

backup_and_remove() {
    local target="$1"
    local full_path="$HOME/$target"
    
    if [ -e "$full_path" ] || [ -L "$full_path" ]; then
        echo "Backing up and removing: $target"
        mkdir -p "$BACKUP_DIR/$(dirname "$target")"
        
        if [ -L "$full_path" ]; then
            cp -P "$full_path" "$BACKUP_DIR/$target" 2>/dev/null || true
        else
            cp -r "$full_path" "$BACKUP_DIR/$target" 2>/dev/null || true
        fi
        
        rm -rf "$full_path"
    fi
}

echo "Checking for conflicts..."

# Test stow to see what conflicts exist
conflicts=$(stow -n -v . 2>&1 | grep "existing target is not owned by stow" | sed 's/.*existing target is not owned by stow: //')

if [ -n "$conflicts" ]; then
    echo "Found conflicts, creating backups..."
    mkdir -p "$BACKUP_DIR"
    
    echo "$conflicts" | while read -r conflict; do
        if [ -n "$conflict" ]; then
            backup_and_remove "$conflict"
        fi
    done
fi

echo "Stowing dotfiles..."
stow -v . || exit 1

if [ -f ".tmux.conf" ]; then
    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$TPM_DIR" ]; then
        echo "Installing tmux plugin manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi
fi

echo "Setup complete! Backups stored in $BACKUP_DIR"
echo "Run 'source ~/.zshrc' if needed."
