#!/bin/zsh

ALIASES_DIR="${ZDOTDIR}/aliases"

source "${ALIASES_DIR}/aliases_common.zsh"
source "${ALIASES_DIR}/remaps.zsh"

if is_machine "mac"; then
  source "${ALIASES_DIR}/aliases_mac.zsh"
  source "${ALIASES_DIR}/suffix_aliases_mac.zsh"
elif is_machine "linux"; then
  source "${ALIASES_DIR}/aliases_linux.zsh"
  source "${ALIASES_DIR}/suffix_aliases_linux.zsh"
fi
