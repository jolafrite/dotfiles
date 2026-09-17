#!/bin/zsh

FUNCTIONS_DIR="${ZDOTDIR}/functions"

source "${FUNCTIONS_DIR}/functions_common.zsh"

if is_machine "mac"; then
  source "${FUNCTIONS_DIR}/functions_mac.zsh"
elif is_machine "linux"; then
  source "${FUNCTIONS_DIR}/functions_linux.zsh"
fi

