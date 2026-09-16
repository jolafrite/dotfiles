#!/usr/bin/env zsh

if [[ -z "$PS1" ]]; then
  return
fi

source_if_exists() {
  local quiet=0
  while getopts 'q' opt; do
    case "$opt" in
      q) quiet=1 ;;
      *) ;;
    esac
  done
  shift "$((OPTIND - 1))"
  
  if [[ -r "$1" ]]; then
    source "$1"
  else
    (( quiet )) || printf "Could not source %s\n" "$1"
    return 1
  fi
}

source "${ZDOTDIR}/env_config.zsh"
source "${ZDOTDIR}/prompt.zsh"
source "${ZDOTDIR}/functions.zsh"
source "${ZDOTDIR}/cd.zsh"
source "${ZDOTDIR}/completion.zsh"
source "${ZDOTDIR}/lazy.zsh"
source "${ZDOTDIR}/progressive_enhancement.zsh"
source "${ZDOTDIR}/updates.zsh"
source "${ZDOTDIR}/source_aliases.zsh"

alias u='rj'

is_machine "mac" && {
  source "${ZDOTDIR}/mac.zsh"
}

havecmd basher && eval "$(basher init - zsh)"

source "${ZDOTDIR}/cache_aliases.zsh"

if [[ -f "$ZDOTDIR/.zshrc_local" ]]; then
  source "$ZDOTDIR/.zshrc_local"
fi

fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
compinit

export PNPM_HOME="$XDG_DATA_HOME/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
