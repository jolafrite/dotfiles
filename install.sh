#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

on_error() {
	err "Last command failed"
	info "Finishing..."
}

wait_input() {
	read -p -r "Press enter to continue:"
}

main() {
	info "Installing..."
}
