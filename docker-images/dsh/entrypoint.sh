#!/bin/sh
set -e

# 1. Load GitHub token from Podman/Docker secret if available
if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
fi

# 2. Ensure cloudflared log directory exists and is writable by the dsh user
mkdir -p /home/dsh/.cloudflared

# 3. Start cloudflared tunnel in the background
cloudflared tunnel run dsh >/home/dsh/.cloudflared/cloudflared.log 2>&1 &

# 4. dsh web binds to 127.0.0.1; expose it on the container's external IP
#    so the -p 3080:3080 port mapping and SSH tunnel can reach it
CONTAINER_IP=$(hostname -I | awk '{print $1}')
socat TCP-LISTEN:3080,reuseaddr,fork,bind="$CONTAINER_IP" TCP:127.0.0.1:3080 >/dev/null 2>&1 &

# 5. Execute the main command passed to the container
exec "$@"