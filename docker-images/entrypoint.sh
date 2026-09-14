#!/usr/bin/env sh
set -e

if [ -z "$TERM" ]; then
    export TERM=xterm-256color
fi

if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
fi

mkdir -p /home/dsh/.cloudflared
cloudflared tunnel run dsh >/home/dsh/.cloudflared/cloudflared.log 2>&1 &

CONTAINER_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$CONTAINER_IP" ]; then
  CONTAINER_IP="0.0.0.0"
fi

socat TCP-LISTEN:3080,reuseaddr,fork,bind="$CONTAINER_IP" TCP:127.0.0.1:3080 >/dev/null 2>&1 &

9router --skip-update --no-browser -p 20128 -H 0.0.0.0 &

bash -c "$(curl -fsSL https://raw.githubusercontent.com/jolafrite/dotfiles/main/dotfiles)"

# # Set environment for zsh to find dotfiles config
# export XDG_CONFIG_HOME="$HOME/.config"
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Persist ZDOTDIR in /etc/zsh/zshenv so all zsh sessions find it
# sudo tee -a /etc/zsh/zshenv << EOF

# # Dotfiles zsh config
# export XDG_CONFIG_HOME="\$HOME/.config"
# export ZDOTDIR="\$XDG_CONFIG_HOME/zsh"
# export PATH="\$HOME/.dotfiles/.local/scripts/generic:\$PATH"
# export PATH="\$HOME/.dotfiles/.local/scripts/cross-platform:\$PATH"
# EOF

exec "$@"
