#!/usr/bin/env zsh
update-apt() { sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y; }
update-nvim() {
  echo "Updating nvim..."
  local arch; arch=$(uname -m)
  case "$arch" in
    x86_64)  url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz" ;;
    aarch64) url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-arm64.tar.gz" ;;
    *) echo "Unsupported architecture: $arch"; return 1 ;;
  esac
  local tmpFolder; tmpFolder="$(mktemp -d)"; local destination="$HOME/.local/bin/"
  pushd "$tmpFolder"
  curl -LO "$url"; tar xzvf nvim-linux*.tar.gz
  mkdir -p "$destination"; rm -rf "$destination/nvim"; mv ./nvim-* "$destination/nvim"
  popd; rm -rf "$tmpFolder"
}
update-all() { update-apt; update-cargo; update-golang; update-node; update-nvim; }