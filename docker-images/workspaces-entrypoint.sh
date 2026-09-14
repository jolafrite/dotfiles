#!/usr/bin/env bash
set -eu

# --- SSH key setup ---
mkdir -p /home/app/.ssh
chmod 700 /home/app/.ssh

if [ -n "${SSH_PUBLIC_KEY:-}" ]; then
  echo "$SSH_PUBLIC_KEY" > /home/app/.ssh/authorized_keys
  chmod 600 /home/app/.ssh/authorized_keys
  chown -R app:app /home/app/.ssh
fi

# --- Git identity ---
git config --global user.name  "${GIT_AUTHOR_NAME:-jolafigue}"
git config --global user.email "${GIT_AUTHOR_EMAIL:-jonathan.houze+bot@gmail.com}"

# --- Jujutsu identity ---
if command -v jj >/dev/null 2>&1; then
  jj config --git-user.name  "${GIT_AUTHOR_NAME:-jolafigue}" 2>/dev/null || true
  jj config --git-user.email "${GIT_AUTHOR_EMAIL:-jonathan.houze+bot@gmail.com}" 2>/dev/null || true
  jj config --user.name  "${JJ_USER_NAME:-jolafigue}" 2>/dev/null || true
  jj config --user.email "${JJ_USER_EMAIL:-jonathan.houze+bot@gmail.com}" 2>/dev/null || true
fi

# --- GitHub token ---
if [ -f /run/secrets/dsh_github_token ]; then
  GH_TOKEN=$(cat /run/secrets/dsh_github_token)
  echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null || true
  export GH_TOKEN
fi

# --- Start SSH daemon ---
echo "[workspace] starting SSHD on port 2222"
/usr/sbin/sshd -D -p 2222 &

# --- Keep container alive ---
echo "[workspace] ready; waiting for connections"
wait