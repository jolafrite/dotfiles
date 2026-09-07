#!/bin/zsh
ALIAS_DIR="${ZDOTDIR}/aliases"
source "${ALIAS_DIR}/aliases_common"
source "${ALIAS_DIR}/remaps"
if is_machine "mac"; then
  source "${ALIAS_DIR}/aliases_mac"
  source "${ALIAS_DIR}/suffix_aliases_mac"
elif is_machine "linux"; then
  source "${ALIAS_DIR}/aliases_linux"
  source "${ALIAS_DIR}/suffix_aliases_linux"
fi