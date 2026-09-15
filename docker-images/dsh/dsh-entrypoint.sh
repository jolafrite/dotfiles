#!/usr/bin/env bash
set -eu

DSH_PORT="${DSH_PORT:-3079}"
PROXY_PORT="${PROXY_PORT:-3080}"
LOG_DIR="${LOG_DIR:-/var/log/dsh}"
READY_TIMEOUT="${READY_TIMEOUT:-120}"

# GitHub token from secret
if [ -f /run/secrets/dsh_github_token ]; then
  export GH_TOKEN="$(cat /run/secrets/dsh_github_token)"
fi

DSH_PID=""
PROXY_PID=""
TAIL_PIDS=""

cleanup() {
    trap - EXIT INT TERM
    echo "[dsh] shutting down"
    for p in $TAIL_PIDS; do kill "$p" 2>/dev/null || true; done
    if [ -n "$PROXY_PID" ]; then kill "$PROXY_PID" 2>/dev/null || true; fi
    if [ -n "$DSH_PID" ]; then kill "$DSH_PID" 2>/dev/null || true; fi
    end=$(( $(date +%s) + 10 ))
    while [ "$(date +%s)" -lt "$end" ]; do
        alive=0
        for p in $PROXY_PID $DSH_PID; do
            if [ -n "$p" ] && kill -0 "$p" 2>/dev/null; then alive=1; fi
        done
        [ "$alive" -eq 1 ] || break
        sleep 0.2
    done
    for p in $PROXY_PID $DSH_PID; do
        [ -z "$p" ] || kill -9 "$p" 2>/dev/null || true
    done
    for p in $PROXY_PID $DSH_PID; do
        [ -z "$p" ] || wait "$p" 2>/dev/null || true
    done
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

probe() {
    node -e "fetch('http://127.0.0.1:$1/').then(()=>process.exit(0)).catch(()=>process.exit(1))" >/dev/null 2>&1
}

echo "[dsh] starting DSH on port $DSH_PORT"
dsh web --port "$DSH_PORT" --no-open > "$LOG_DIR/dsh.log" 2>&1 &
DSH_PID=$!
tail -qF "$LOG_DIR/dsh.log" & TAIL_PIDS="$TAIL_PIDS $!"

i=0
while [ "$i" -lt "$READY_TIMEOUT" ]; do
    if probe "$DSH_PORT"; then break; fi
    if ! kill -0 "$DSH_PID" 2>/dev/null; then
        echo "[dsh] DSH exited during startup; last log lines:" >&2
        tail -n 20 "$LOG_DIR/dsh.log" >&2
        exit 1
    fi
    i=$((i+1))
    sleep 1
done
[ "$i" -lt "$READY_TIMEOUT" ] || { echo "[dsh] DSH not ready after ${READY_TIMEOUT}s" >&2; exit 1; }
echo "[dsh] ready (pid $DSH_PID)"

echo "[proxy] starting proxy on port $PROXY_PORT -> $DSH_PORT"
socat tcp-listen:"$PROXY_PORT",fork,reuseaddr tcp:127.0.0.1:"$DSH_PORT" > "$LOG_DIR/proxy-socat.log" 2>&1 &
PROXY_PID=$!

i=0
while [ "$i" -lt 30 ]; do
    if probe "$PROXY_PORT"; then break; fi
    if ! kill -0 "$PROXY_PID" 2>/dev/null; then
        echo "[proxy] socat exited during startup" >&2
        exit 1
    fi
    i=$((i+1))
    sleep 0.5
done
[ "$i" -lt 30 ] || { echo "[proxy] not ready after 15s" >&2; exit 1; }
echo "[proxy] ready (pid $PROXY_PID)"

echo "[dsh] all services up; waiting"
wait -n "$DSH_PID" "$PROXY_PID" || true
echo "[dsh] a child exited; shutting down"
exit 1
