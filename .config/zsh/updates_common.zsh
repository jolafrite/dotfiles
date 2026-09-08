#!/usr/bin/env zsh
update-cargo() { echo "Updating cargo packages..."; cargo install-update -a; }
update-golang() { echo "Updating golang packages..."; cd || return $?; spkglist "$PACKAGE_DIR/go_packages.txt" | awk '{ print $2 "@latest" }' | xargs -I '{}' go install -v "{}"; cd "$OLDPWD" || return $?; }
update-node() { echo "Updating global node packages..."; pnpm global --prefix "$HOME/.local/" upgrade; }