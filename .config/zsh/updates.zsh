#!/bin/zsh

UPDATES_DIR="${ZDOTDIR}/updates"

source "${UPDATES_DIR}/updates_common.zsh"

if is_machine "mac"; then
  source "${UPDATES_DIR}/updates_mac.zsh"
elif is_machine "linux"; then
  source "${UPDATES_DIR}/updates_linux.zsh"
fi
