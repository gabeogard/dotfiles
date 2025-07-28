[[ -n "${ZSH_DEBUGRC+1}" ]] && zmodload zsh/zprof

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
setopt promptsubst   
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_find_no_dups


export EDITOR=vim
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"

[[ -e ~/bin/source_env ]] && source ~/bin/source_env
[[ -e ~/.env ]] && source ~/.env

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias zshrcu="source ~/.zshrc"
alias zshrc="nvim ~/.zshrc"
alias zsh_profile_startup="time ZSH_DEBUGRC=1 zsh -i -c exit"

if command -v eza &> /dev/null; then
  zstyle ':completion:*' list-colors "${(s.:.)EZA_COLORS}"
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=3 --color=always $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --tree --level=3 --color=always $realpath'
  alias l="eza --icons=always --all --show-symlinks --oneline --git-ignore"
else
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
  alias ls="ls --color"
fi

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

bindkey \^U backward-kill-line
autoload edit-command-line; zle -N edit-command-line
bindkey "^X^E" edit-command-line

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no  

zinit wait lucid for \
  OMZL::git.zsh \
  OMZP::git


zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
  atload'export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec; [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"' \
  atload'export NVM_DIR="$HOME/.nvm"; [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"' \
  atload'command -v colima &> /dev/null && export TESTCONTAINERS_HOST_OVERRIDE=$(colima ls -j | jq -r ".address")' \
  zdharma-continuum/fast-syntax-highlighting \
  zsh-users/zsh-completions \
  MichaelAquilina/zsh-you-should-use

zinit wait lucid light-mode for \
  atinit'eval "$(fzf --zsh)"' \
  atload'eval "$(zoxide init --cmd z zsh)"' \
  junegunn/fzf-git.sh \
  Aloxaf/fzf-tab

zinit ice wait'!' lucid nocd \
  atload='_omp_precmd'
zinit snippet "${XDG_CONFIG_HOME:-${HOME}/.config}/zsh/ohmyposh.zsh"

sd() {
  cd ~/.config/dotfiles || return 1
  git pull || return 1
  sh init_symlinks.sh || return 1
  cd - > /dev/null
}

# Debug profiling (end)
[[ -n "${ZSH_DEBUGRC+1}" ]] && zprof
