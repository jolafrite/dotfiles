#!/bin/sh
set -e

if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
fi

mkdir -p /home/dsh/.cloudflared
cloudflared tunnel run dsh >/home/dsh/.cloudflared/cloudflared.log 2>&1 &

CONTAINER_IP=$(hostname -I | awk '{print $1}')
socat TCP-LISTEN:3080,reuseaddr,fork,bind="$CONTAINER_IP" TCP:127.0.0.1:3080 >/dev/null 2>&1 &

# Start 9router (multi-provider router)
NINEROUTER_PEER_TOKEN=headroom 9router --skip-update --no-browser -p 20128 -H 0.0.0.0 &

# Wait for 9router to be ready
for i in $(seq 1 30); do
  curl -sf http://localhost:20128/dashboard && break
  sleep 1
done

# Install dotfiles from GitHub repo if not already present
if [ ! -d /home/dsh/.dotfiles ]; then
  echo "Cloning dotfiles repo..."
  cd /home/dsh
  git clone https://github.com/jolafrite/dotfiles.git .dotfiles 2>&1 || echo "Clone failed, continuing..."
fi

# Set up .config symlink to dotfiles if not already done
if [ -d /home/dsh/.dotfiles/.config ] && [ ! -L /home/dsh/.config ]; then
  echo "Setting up .config symlink..."
  rm -rf /home/dsh/.config
  ln -s /home/dsh/.dotfiles/.config /home/dsh/.config
fi

# Fix broken trash alias in aliases_common (uses $@ which is invalid in aliases)
# The Linux version defines trash as a function, which is correct
if [ -f /home/dsh/.config/zsh/aliases/aliases_common ]; then
  sed -i '/^alias trash=/d' /home/dsh/.config/zsh/aliases/aliases_common 2>/dev/null || true
fi

# Set environment for zsh to find dotfiles config
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Persist ZDOTDIR in /etc/zsh/zshenv so all zsh sessions find it
sudo tee -a /etc/zsh/zshenv << EOF

# Dotfiles zsh config
export XDG_CONFIG_HOME="\$HOME/.config"
export ZDOTDIR="\$XDG_CONFIG_HOME/zsh"
export PATH="\$HOME/.dotfiles/.local/scripts/generic:\$PATH"
export PATH="\$HOME/.dotfiles/.local/scripts/cross-platform:\$PATH"
EOF

exec "$@"