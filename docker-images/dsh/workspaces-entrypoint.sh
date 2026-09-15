#!/usr/bin/env bash
set -eu

if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
  echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null || true
  unset GH_TOKEN
fi

mkdir -p /home/app/.ssh
chmod 700 /home/app/.ssh

if [ -n "${SSH_PUBLIC_KEY:-}" ]; then
  echo "$SSH_PUBLIC_KEY" > /home/app/.ssh/authorized_keys
  chmod 600 /home/app/.ssh/authorized_keys
  chown -R app:app /home/app/.ssh
fi

git config --global user.name  "${GIT_AUTHOR_NAME}"
git config --global user.email "${GIT_AUTHOR_EMAIL}"

if command -v jj >/dev/null 2>&1; then
  jj config --user.name  "${JJ_USER_NAME}" 2>/dev/null || true
  jj config --user.email "${JJ_USER_EMAIL}" 2>/dev/null || true
fi

echo "[workspace] starting SSHD on port 2222"
/usr/sbin/sshd -D -p 2222 &
SSHD_PID=$!

cleanup() {
    trap - TERM INT
    echo "[workspace] stopping sshd (pid $SSHD_PID)"
    kill "$SSHD_PID" 2>/dev/null || true
    wait "$SSHD_PID" 2>/dev/null || true
    exit 0
}
trap cleanup TERM INT

echo "[workspace] ready; waiting for connections"
wait "$SSHD_PID"
