#!/usr/bin/env bash
set -eu pipefail

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
elif [ -f /home/app/.ssh/dsh-workspace.pub ]; then
  cp /home/app/.ssh/dsh-workspace.pub /home/app/.ssh/authorized_keys
fi
if [ -f /home/app/.ssh/authorized_keys ]; then
  chmod 600 /home/app/.ssh/authorized_keys
fi
chown -R app:app /home/app/.ssh /home/app/.sshd

git config --global init.defaultBranch main
git config --global pull.rebase        true
git config --global safe.directory     '*'

echo "[workspace] starting SSHD on port 2222"
exec /usr/sbin/sshd -D -p 2222 -e
