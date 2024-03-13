#!/bin/zsh

update-basher() {
	echo "Updating bash scripts..."
	(cd "$(basher package-path .)" && git pull)
	basher-upgrade-all
}

update-brew() {
  brew update &&
    brew bundle -v --file="$PACKAGE_DIR/Brewfile"
    brew autoremove &&
    brew cleanup -s
}

update-cargo() {
	echo "Updating cargo packages..."
	cargo install-update -a
}

update-golang() {
	echo "Updating golang packages..."
	cd || return $?
	spkglist "$PACKAGE_DIR/go_packages.txt" | awk '{ print $2 "@latest" }' | xargs -I '{}' go install -v "{}"
	cd "$OLDPWD" || return $?
}

update-node() {
	echo "Updating global node packages..."
	pnpm global --prefix "${HOME}/.local/" upgrade
}

update-all() {
	update-basher
  update-brew
	update-cargo
	update-golang
	update-node
	# update_pip
	# pipx upgrade-all
	# update_ranger_plugins
	# update_todo_addons
}
