# This file sets zsh history configuration
# and environment variables/aliases
# which move config/data files
# for applications to closer
# adhere to the XDG standard
# also sets any environment variables
# for shell tools/applications
#
# The environment-variable section is POSIX-sh compatible so that
# env_config.zsh can also be sourced by bash (via ~/.env, which is
# sourced by ~/.profile and by the yadm bootstrap script). Only the
# history configuration below is zsh-specific and is guarded.

# --- environment variables (consolidated from ~/.env) ---

# XDG base directories
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

# locale
export LANG="en_US.UTF-8"
export LANGUAGE="en"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# general tools
export GPG_TTY=$(tty)
export READER='okular'
export TERM="screen-256color"
export TERMINAL='wezterm'
export VISUAL='nvim'

# shell / package-manager paths
export ZSH_DOT_DIR="$XDG_CONFIG_HOME/zsh"
export ZDOTDIR=$ZSH_DOT_DIR
export HOMEBREW_HOME="$XDG_DATA_HOME/homebrew"
export YADM_DOT_DIR="$XDG_CONFIG_HOME/yadm"
export YADM_PACKAGE_DIR="$YADM_DOT_DIR/package_lists"

# global package lists (consumed by yadm bootstrap)
export GO_PACKAGE_LIST="$YADM_PACKAGE_DIR/go_packages.txt"
export CARGO_PACKAGE_LIST="$YADM_PACKAGE_DIR/cargo_packages.txt"
export PYTHON_PACKAGE_LIST="$YADM_PACKAGE_DIR/python3_packages.txt"
export PIPX_PACKAGE_LIST="$YADM_PACKAGE_DIR/pipx_packages.txt"
export GH_PACKAGE_LIST="$YADM_PACKAGE_DIR/gh_extension_packages.txt"
export GLOBAL_GEM_LIST="$YADM_PACKAGE_DIR/ruby_packages.txt"
export NODE_PACKAGE_LIST="$YADM_PACKAGE_DIR/node_packages.txt"
export COMPUTER_NODE_PACKAGE_LIST="$YADM_PACKAGE_DIR/computer_node_packages.txt"
export BASH_PACKAGE_LIST="$YADM_PACKAGE_DIR/bash_packages.txt"

# common path modifications
export PATH="\
:$XDG_DATA_HOME/shortcuts:\
:$HOME/.local/bin:\
:$HOME/.local/scripts/mac:\
:$HOME/.local/scripts/cross-platform:\
:$HOME/.local/scripts/generic:\
:$XDG_DATA_HOME/go/bin:\
:$XDG_DATA_HOME/cargo/bin:\
:$XDG_DATA_HOME/pubcache/bin:\
:$PATH"

# normalize PATH entries: strip leading/trailing whitespace from each
# entry so inherited spaced entries (e.g. from the parent process) don't
# make directories like ~/.local/scripts/generic unsearchable
export PATH="$(printf '%s' "$PATH" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/[[:space:]]*:[[:space:]]*/:/g')"

export HOMEBREW_CASK_OPTS="--appdir=~/Applications --adopt"

ON_OS="$(on_os)"
export ON_OS

export BLOCKSIZE=1k

# --- zsh history configuration (zsh only) ---
if [ -n "$ZSH_VERSION" ]; then
HISTFILE="${ZDOTDIR}/.zsh_history"
HISTFILESIZE=10000000000000000
HISTSIZE=10000000000000000
SAVEHIST=10000000000000000
HISTTIMEFORMAT="[%F %T] "

setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY     # append to history file instead of replacing
setopt HIST_REDUCE_BLANKS # delete empty lines from history file
setopt HIST_IGNORE_SPACE  # ignore lines that start with space
setopt HIST_NO_STORE      # Do not add history and fc commands to the history
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY # save time/duration to history file
fi

export CDPATH=".:${REPOS}"

export YADM_DIR="${XDG_CONFIG_HOME}/yadm"
export PACKAGE_DIR="${YADM_DIR}/package_lists"

# Github
USERNAME_ID=$(id -un) # whoami has been deprecated
export GITHUBDIR="github-$USERNAME_ID"

# Go
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOROOT="$HOME/.go"

# Rust
export CARGO_HOME="$HOME/.cargo"

# Python/Venv related
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PIPENV_PYTHON="${PYENV_ROOT}/shims/python"
export PYTHONBREAKPOINT='ipdb.set_trace'

# MySQL History File
export MYSQL_HISTFILE="${XDG_CACHE_HOME}/mysql_history"

# Node History File
export NODE_REPL_HISTORY="${XDG_CACHE_HOME}/node_repl_history"

# Python History File
# set PYTHON_STARTUP python file, which runs when an
# interactive shell is opened
# reads from the history file in ~/.cache/python_history
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/pythonrc"

# move ipython data directory
export IPYTHONDIR="$XDG_DATA_HOME/ipython"

# SQLite history file
export SQLITE_HISTORY="${XDG_CACHE_HOME}/sqlite_history"

# ruby: only seems to work for bundle-installed gems
# the rest of the typically installed 'gem install <gem>'
# go to ~/.gem
export GEM_HOME="$XDG_DATA_HOME/gem"

# shortcuts: https://github.com/seanbreckenridge/shortcuts
export SHORTCUTS_DIR="$XDG_DATA_HOME/shortcuts"

# ignore less history
export LESSHISTFILE='-'

# inputrc
export INPUTRC="${XDG_CONFIG_HOME}/inputrc"

# Corrections
# aliases that fix the config/history path of commands
alias irb='ruby "${XDG_CONFIG_HOME}/irbrc"'
alias wget='wget --hsts-file "${XDG_CACHE_HOME}/wget-hsts"'

# general environment variable configuration
export YSU_MESSAGE_FORMAT="$(tput setaf 1)>>> %alias_type: %alias $(tput sgr0)"

# bat theme
export BAT_THEME='Dracula'

# fzf configuration
export FZF_DEFAULT_OPTS=''
export FZF_DEFAULT_COMMAND='fd -IHL -E .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND='fd -L -t d'

# colors for manpages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

export EDITOR='editor' # basic nvim wrapper
export PAGER='less'