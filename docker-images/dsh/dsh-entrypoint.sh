#!/usr/bin/env bash
set -eu pipefail

DSH_PORT="${DSH_PORT:-3079}"
PROXY_PORT="${PROXY_PORT:-3080}"
LOG_DIR="${LOG_DIR:-/var/log/dsh}"
READY_TIMEOUT="${READY_TIMEOUT:-120}"

[ -f /run/secrets/dsh_github_token ] && export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"

PIDS=""

probe() {
    node -e "fetch('http://127.0.0.1:$1/').then(()=>process.exit(0)).catch(()=>process.exit(1))" >/dev/null 2>&1
}

cleanup() {
    trap - EXIT INT TERM
    echo "[dsh] shutting down"
    kill $PIDS 2>/dev/null || true
    wait $PIDS 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

wait_ready() { 
    local i=0
    while (( i < $2 )); do
        probe "$1" && return 0
        if ! kill -0 "$3" 2>/dev/null; then
            echo "[$4] exited during startup; last log lines:" >&2
            [ -z "${5:-}" ] || tail -n 20 "$5" >&2
            return 1
        fi
        i=$((i + 1)); sleep 1
    done
    echo "[$4] not ready after $2s" >&2
    return 1
}

echo "[dsh] starting DSH on port $DSH_PORT"
dsh web --port "$DSH_PORT" --no-open > "$LOG_DIR/dsh.log" 2>&1 &
DSH_PID=$!; PIDS="$PIDS $DSH_PID"
tail -qF "$LOG_DIR/dsh.log" & PIDS="$PIDS $!"

wait_ready "$DSH_PORT" "$READY_TIMEOUT" "$DSH_PID" dsh "$LOG_DIR/dsh.log"
echo "[dsh] ready (pid $DSH_PID)"

echo "[proxy] starting proxy on port $PROXY_PORT -> $DSH_PORT"
socat tcp-listen:"$PROXY_PORT",fork,reuseaddr tcp:127.0.0.1:"$DSH_PORT" > "$LOG_DIR/proxy-socat.log" 2>&1 &
PROXY_PID=$!; PIDS="$PIDS $PROXY_PID"

wait_ready "$PROXY_PORT" 30 "$PROXY_PID" proxy
echo "[proxy] ready (pid $PROXY_PID)"

echo "[dsh] all services up; waiting"
wait -n "$DSH_PID" "$PROXY_PID" || true
echo "[dsh] a child exited; shutting down"
exit 1
