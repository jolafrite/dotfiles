#!/usr/bin/env zsh

: "$LANG:=\"en_US.UTF-8\""
: "$LANGUAGE:=\"en\""
: "$LC_CTYPE:=\"en_US.UTF-8\""
: "$LC_ALL:=\"en_US.UTF-8\""
export LANG LANGUAGE LC_CTYPE LC_ALL

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
eval "$(~/homebrew/bin/brew shellenv)"

export LIBSQLITE="$(brew --prefix)/opt/sqlite/lib/libsqlite3.dylib"

export TERM="screen-256color"
export GPG_TTY=$(tty)
export EDITOR="nvim"
export HISTSIZE=10000
export SAVEHIST=10000

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

export MANPAGER='less -s'

BREW_PREFIX="$(brew --prefix)"

# changes ctrl-u to delete everything to the left of the cursor, rather than the whole line
bindkey "^U" backward-kill-line
bindkey "^E" kill-line
# alt-del delete word forwards
bindkey '^[[3;3~' kill-word

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "zap-zsh/exa"
plug "zap-zsh/fnm"
plug "chivalryq/git-alias"
plug "z-shell/zsh-zoxide"
plug "Freed-Wu/fzf-tab-source"
plug "zap-zsh/fzf"
plug "Aloxaf/fzf-tab"
plug "MichaelAquilina/zsh-you-should-use"
plug "wintermi/zsh-brew"
plug "wintermi/zsh-golang"
plug "wintermi/zsh-rust"

# Load and initialise completion system
autoload -Uz compinit
compinit

#
# zsh syntax highlighting clears and restores aliases after .zshenv is loaded
# this keeps ls and ll aliased correctly
alias ls="exa --group-directories-first -G  --color auto --icons -a -s type"
alias ll="exa --group-directories-first -l --color always --icons -a -s type"

# Golang
export GOPATH="$HOME/go"
[ -d "$GOPATH/bin" ] && PATH="$GOPATH/bin:$PATH"
[ -d "/usr/local/go/bin" ] && PATH="/usr/local/go/bin:$PATH"

# Rust
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env


