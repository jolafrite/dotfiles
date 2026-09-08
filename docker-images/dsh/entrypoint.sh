#!/bin/sh
set -e

# 1. Load GitHub token from Podman/Docker secret if available
if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
fi

# 2. Ensure cloudflared log directory exists and is writable by the dsh user
mkdir -p /home/dsh/.cloudflared

# 3. dsh web binds to 127.0.0.1 for security; expose it on 0.0.0.0:3081
#    so podman port mapping (3080->3081) / cloudflare tunnel can reach it
socat TCP-LISTEN:3081,reuseaddr,fork TCP:127.0.0.1:3080 >/dev/null 2>&1 &

# 4. Start cloudflared tunnel in the background (only if tunnel credentials exist)
if [ -f /home/dsh/.cloudflared/cert.pem ]; then
  cloudflared tunnel run dsh >/home/dsh/.cloudflared/cloudflared.log 2>&1 &
fi

# 5. Execute the main command passed to the container
exec "$@"
