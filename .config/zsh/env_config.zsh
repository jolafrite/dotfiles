#!/usr/bin/env zsh

export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Movies"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_BIN="$HOME/.local/bin"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export FILES_DIR="$HOME/Files"
export REPOS="$HOME/Development"
export SCREENSHOTS="$XDG_PICTURES_DIR/Screenshots"

export LANG="en_US.UTF-8"
export LANGUAGE="en"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export GPG_TTY=$(tty)
export READER='okular'
export TERM="screen-256color"
export TERMINAL='wezterm'
export VISUAL='nvim'
export EDITOR='editor'
export PAGER='less'

export ZSH_DOT_DIR="$XDG_CONFIG_HOME/zsh"
export ZDOTDIR="$ZSH_DOT_DIR"
export HOMEBREW_HOME="$XDG_DATA_HOME/homebrew"
export YADM_DOT_DIR="$XDG_CONFIG_HOME/yadm"
export YADM_PACKAGE_DIR="$YADM_DOT_DIR/package_lists"

export GO_PACKAGE_LIST="$YADM_PACKAGE_DIR/go_packages.txt"
export CARGO_PACKAGE_LIST="$YADM_PACKAGE_DIR/cargo_packages.txt"
export PYTHON_PACKAGE_LIST="$YADM_PACKAGE_DIR/python3_packages.txt"
export PIPX_PACKAGE_LIST="$YADM_PACKAGE_DIR/pipx_packages.txt"
export GH_PACKAGE_LIST="$YADM_PACKAGE_DIR/gh_extension_packages.txt"
export GLOBAL_GEM_LIST="$YADM_PACKAGE_DIR/ruby_packages.txt"
export NODE_PACKAGE_LIST="$YADM_PACKAGE_DIR/node_packages.txt"
export COMPUTER_NODE_PACKAGE_LIST="$YADM_PACKAGE_DIR/computer_node_packages.txt"
export BASH_PACKAGE_LIST="$YADM_PACKAGE_DIR/bash_packages.txt"

typeset -U path
path=(
  "$XDG_DATA_HOME/shortcuts"
  "$HOME/.local/bin"
  "$HOME/.local/scripts/mac"
  "$HOME/.local/scripts/cross-platform"
  "$HOME/.local/scripts/generic"
  "$XDG_DATA_HOME/go/bin"
  "$XDG_DATA_HOME/cargo/bin"
  "$XDG_DATA_HOME/pubcache/bin"
  $path
)
export PATH

export HOMEBREW_CASK_OPTS="--appdir=~/Applications --adopt"
export BLOCKSIZE=1k

export CDPATH=".:${REPOS}"
export YADM_DIR="${XDG_CONFIG_HOME}/yadm"
export PACKAGE_DIR="${YADM_DIR}/package_lists"

export GITHUBDIR="github-$(id -un)"

export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOROOT="$HOME/.go"

export CARGO_HOME="$HOME/.cargo"

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PIPENV_PYTHON="${PYENV_ROOT}/shims/python"
export PYTHONBREAKPOINT='ipdb.set_trace'
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/pythonrc"
export IPYTHONDIR="$XDG_DATA_HOME/ipython"

export MYSQL_HISTFILE="${XDG_CACHE_HOME}/mysql_history"
export NODE_REPL_HISTORY="${XDG_CACHE_HOME}/node_repl_history"
export SQLITE_HISTORY="${XDG_CACHE_HOME}/sqlite_history"
export LESSHISTFILE='-'
export INPUTRC="${XDG_CONFIG_HOME}/inputrc"

export GEM_HOME="$XDG_DATA_HOME/gem"
export SHORTCUTS_DIR="$XDG_DATA_HOME/shortcuts"

export BAT_THEME='Dracula'

export FZF_DEFAULT_OPTS=''
export FZF_DEFAULT_COMMAND='fd -IHL -E .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND='fd -L -t d'

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

export YSU_MESSAGE_FORMAT="$(tput setaf 1)>>> %alias_type: %alias $(tput sgr0)"

alias irb='ruby "${XDG_CONFIG_HOME}/irbrc"'
alias wget='wget --hsts-file "${XDG_CACHE_HOME}/wget-hsts"'

if [[ -n "$ZSH_VERSION" ]]; then
  HISTFILE="${ZDOTDIR}/.zsh_history"
  HISTSIZE=10000000
  SAVEHIST=10000000
  HISTTIMEFORMAT="[%F %T] "
  
  setopt INC_APPEND_HISTORY
  setopt APPEND_HISTORY
  setopt HIST_REDUCE_BLANKS
  setopt HIST_IGNORE_SPACE
  setopt HIST_NO_STORE
  setopt HIST_FIND_NO_DUPS
  setopt HIST_IGNORE_ALL_DUPS
  setopt EXTENDED_HISTORY
fi
