#!/bin/sh
set -e

if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
fi

mkdir -p /home/dsh/.cloudflared
cloudflared tunnel run dsh >/home/dsh/.cloudflared/cloudflared.log 2>&1 &

CONTAINER_IP=$(hostname -I | awk '{print $1}')
socat TCP-LISTEN:3080,reuseaddr,fork,bind="$CONTAINER_IP" TCP:127.0.0.1:3080 >/dev/null 2>&1 &

exec "$@"