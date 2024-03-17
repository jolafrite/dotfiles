#!/usr/bin/env bash

. "$HOME/env"

# variables which ideally should be sourced into the global
# environment since they could be referenced without opening a terminal
# e.g. from my menu bar/window manager/run launcher
if [ -f "${ZDOTDIR}/global_env.sh" ]; then
  # shellcheck disable=SC1091
  . "${ZDOTDIR}/global_env.sh"
fi
