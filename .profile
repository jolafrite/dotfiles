#!/bin/sh
# global configuration/environment
# this is sourced in .xinitrc (when I run startx) on Linux and
# from ~/.zshenv on other operating systems
# mac (see ~/.config/yadm/mac_bootstrap for the generated .zshenv)

## XDG
export XDG_DOWNLOAD_DIR="${HOME}/Downloads"
export XDG_DOCUMENTS_DIR="${HOME}/Documents"
export XDG_PICTURES_DIR="${HOME}/Pictures"
export XDG_VIDEOS_DIR="${HOME}/Movies"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export FILES_DIR="${HOME}/Files"
export REPOS="${HOME}/Development"
export SCREENSHOTS="${XDG_PICTURES_DIR}/Screenshots"

# common path modifications
export PATH="\
${XDG_DATA_HOME}/shortcuts:\
${HOME}/.local/bin:\
${HOME}/.local/scripts/mac:\
${HOME}/.local/scripts/cross-platform:\
${HOME}/.local/scripts/generic:\
${XDG_DATA_HOME}/go/bin:\
${XDG_DATA_HOME}/cargo/bin:\
${XDG_DATA_HOME}/pubcache/bin:\
${PATH}"

ON_OS="$(on_os)"
export ON_OS

: "$LANG:=\"en_US.UTF-8\""
: "$LANGUAGE:=\"en\""
: "$LC_CTYPE:=\"en_US.UTF-8\""
: "$LC_ALL:=\"en_US.UTF-8\""
export LANG LANGUAGE LC_CTYPE LC_ALL

export EDITOR='editor' # basic nvim wrapper
export GPG_TTY=$(tty)
export PAGER='less'
export READER='okular'
export TERM="screen-256color"
export TERMINAL='wezterm'
export VISUAL='nvim'

# define where ZDOTDIR (rest of zsh configuration) is
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

export GOROOT_BOOTSTRAP=$GOROOT

# variables which ideally should be sourced into the global
# environment since they could be referenced without opening a terminal
# e.g. from my menu bar/window manager/run launcher
if [ -f "${ZDOTDIR}/global_env.sh" ]; then
  # shellcheck disable=SC1091
  . "${ZDOTDIR}/global_env.sh"
fi
