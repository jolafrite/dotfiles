#!/bin/zsh

update_brew() {
  brew update &&
    brew bundle -v --file="$PACKAGE_DIR/Brewfile"
    brew autoremove &&
    brew cleanup -s &&
    brew doctor
}

update_cargo() {
	echo "Updating cargo packages..."
	cargo install-update -a
}

update_golang() {
	echo "Updating golang packages..."
	cd || return $?
	spkglist "$PACKAGE_DIR/go_packages.txt" | awk '{ print $2 "@latest" }' | xargs -I '{}' go install -v "{}"
	cd "$OLDPWD" || return $?
}
