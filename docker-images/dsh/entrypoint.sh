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

# Fix locale + unbound variable issues in env_config.zsh:
# - en_US.UTF-8 is not built in the slim image; fall back to C.UTF-8
# - $ZSH_VERSION is unbound when sourced by bash with set -u
if [ -f "$HOME/.config/zsh/env_config.zsh" ]; then
  sed -i \
    -e 's/en_US\.UTF-8/C.UTF-8/g' \
    -e 's/\$ZSH_VERSION/\${ZSH_VERSION:-}/g' \
    "$HOME/.config/zsh/env_config.zsh"
fi

# Restore .dsh context into the volume if missing (e.g. fresh/recreated volume).
# The dsh-home volume overwrites /home/dsh/.dsh, so the image copy is hidden.
# A backup lives at /usr/local/share/dsh-context (outside the volume mount).
if [ ! -f "$HOME/.dsh/profiles/web/node_modules/model-catalog/dist/src/dsh.js" ]; then
  echo "Restoring .dsh context from image backup..."
  mkdir -p "$HOME/.dsh"
  cp -r /usr/local/share/dsh-context/. "$HOME/.dsh/"
fi

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
