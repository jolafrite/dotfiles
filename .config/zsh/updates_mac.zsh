#!/usr/bin/env zsh
update-brew() { brew update && brew bundle -v --file="$PACKAGE_DIR/Brewfile" && brew autoremove && brew cleanup -s; }
update-nvim() {
  echo "Updating nvim..."
  url="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz"
  tmpFolder="$(mktemp -d)"; destination="$HOME/.local/bin/"
  pushd "$tmpFolder"
  curl -LO "$url"; xattr -c ./nvim-macos-arm64.tar.gz; tar xzvf nvim-macos-arm64.tar.gz
  mkdir -p "$destination"; rm -rf "$destination/nvim"; mv ./nvim-macos-arm64 "$destination/nvim"
  popd; rm -rf "$tmpFolder"
}
update-all() { update-brew; update-cargo; update-golang; update-node; update-nvim; }