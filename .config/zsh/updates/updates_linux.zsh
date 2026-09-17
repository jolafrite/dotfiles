#!/usr/bin/env zsh

update-apt() {
  sudo apt-get update -y && \
  sudo apt-get upgrade -y && \
  sudo apt-get autoremove -y && \
  sudo apt-get autoclean -y
}

update-nvim() {
  echo "Updating nvim..."
  local arch
  arch=$(uname -m)

  local url
  case "$arch" in
    x86_64)  url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz" ;;
    aarch64) url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-arm64.tar.gz" ;;
    *) echo "Unsupported architecture: $arch"; return 1 ;;
  esac

  local tmpFolder="$(mktemp -d)"
  local destination="$HOME/.local/bin/"

  pushd "$tmpFolder" >/dev/null
  curl -LO "$url"
  tar xzf nvim-linux*.tar.gz
  mkdir -p "$destination"
  rm -rf "$destination/nvim"
  mv ./nvim-* "$destination/nvim"
  popd >/dev/null
  rm -rf "$tmpFolder"
}

update-all() {
  update-apt
  update-cargo
  update-golang
  update-node
  update-nvim
}
