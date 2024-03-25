# This file sets zsh history configuration
# and environment variables/aliases
# which move config/data files
# for applications to closer
# adhere to the XDG standard
# also sets any environment variables
# for shell tools/applications

# zsh history configuration
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
setopt EXTENDED_HISTORY   # save time/duration to history file

export CDPATH=".:${REPOS}"

export YADM_DIR="${XDG_CONFIG_HOME}/yadm"
export PACKAGE_DIR="${YADM_DIR}/package_lists"

export HOMEBREW_HOME="$XDG_DATA_HOME/homebrew"

export NVIM_DIR="${XDG_CONFIG_HOME}/nvim"

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
