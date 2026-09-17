#!/usr/bin/env bash
set -eu pipefail

if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
  echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null || true
  unset GH_TOKEN
fi

mkdir -p /home/app/.ssh /home/app/.sshd
chmod 700 /home/app/.ssh /home/app/.sshd

for t in rsa ecdsa ed25519; do
  key="/home/app/.ssh/ssh_host_${t}_key"
  [ -f "$key" ] || ssh-keygen -q -t "$t" -f "$key" -N "" -C "workspace-host"
done
chmod 600 /home/app/.ssh/ssh_host_*_key
chmod 644 /home/app/.ssh/ssh_host_*.pub

if [ -n "${SSH_PUBLIC_KEY:-}" ]; then
  printf '%s\n' "$SSH_PUBLIC_KEY" > /home/app/.ssh/authorized_keys
  chmod 600 /home/app/.ssh/authorized_keys
fi
chown -R app:app /home/app/.ssh /home/app/.sshd

git config --global user.name          "${GIT_AUTHOR_NAME}"
git config --global user.email         "${GIT_AUTHOR_EMAIL}"
git config --global init.defaultBranch main
git config --global pull.rebase        true
git config --global safe.directory     '*'

if command -v jj >/dev/null 2>&1; then
  jj config set --user user.name  "${JJ_USER_NAME}"  2>/dev/null || true
  jj config set --user user.email "${JJ_USER_EMAIL}" 2>/dev/null || true
fi

echo "[workspace] starting SSHD on port 2222"
exec /usr/sbin/sshd -D -p 2222 -e
