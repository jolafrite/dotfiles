#!/bin/zsh

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

update-nvim() {
  echo "Updating nvim..."

  url="https://github.com/neovim/neovim/releases/download/stable/nvim-macos-arm64.tar.gz"
  tmpFolder="$(mktemp -d)"
  destination="$HOME/.local/bin/"
  
  pushd "$tmpFolder"
  
  curl -LO "$url"
  xattr -c ./nvim-macos-arm64.tar.gz
  tar xzvf nvim-macos-arm64.tar.gz
  
  mkdir -p "$destination"
  mv ./nvim-macos-arm64 "$destination/nvim"
  
  popd
  
  rm -rf "$tmpFolder"
}

update-node() {
	echo "Updating global node packages..."
	pnpm global --prefix "$HOME/.local/" upgrade
}

update-all() {
  update-brew
  update-cargo
  update-golang
  update-node
  update-nvim
	# update_pip
	# pipx upgrade-all
	# update_ranger_plugins
	# update_todo_addons
}
