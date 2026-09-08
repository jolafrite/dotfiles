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

# 4. Execute the main command passed to the container
exec "$@"