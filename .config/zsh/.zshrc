#!/bin/zsh

if [ -z "$PS1" ]; then
  return
fi

source_if_exists() {
	local quien
	quiet=0
	while getopts 'q' opt; do
		case "$opt" in
		q)
			quiet=1
			;;
		*) ;;
		esac
	done
	shift "$((OPTIND - 1))"
	if [[ -r "$1" ]]; then
		source "$1"
	else
		if ! ((quiet)); then
			printf "Could not source %s\n" "$1"
		fi
		return 1
	fi
}

source "${ZDOTDIR}/env_config.zsh"              # History/Application configuration
source "${ZDOTDIR}/prompt.zsh"                  # prompt configuration
source "${ZDOTDIR}/functions.zsh"               # functions, bindings, command completion
source "${ZDOTDIR}/cd.zsh"                      # functions to change my directory
source "${ZDOTDIR}/completion.zsh"              # zsh completion
source "${ZDOTDIR}/lazy.zsh"                    # lazy load shell tools
source "${ZDOTDIR}/progressive_enhancement.zsh" # slightly improve commands
source "${ZDOTDIR}/updates.zsh"                 # update globally installed lang-specific packages
source "${ZDOTDIR}/source_aliases.zsh"

alias u='rj'

is_machine "mac" && {
  source "${ZDOTDIR}/mac.zsh"
}

havecmd basher && eval "$(basher init - zsh)"

source "${ZDOTDIR}/cache_aliases.zsh"

if [ -f "$ZDOTDIR/.zshrc_local" ]; then
  source "$ZDOTDIR/.zshrc_local"
fi

true
