#!/usr/bin/env zsh

show-fps() { /bin/launchctl setenv MTL_HUD_ENABLED 1; }
hide-fps() { /bin/launchctl setenv MTL_HUD_ENABLED 0; }

proxy-start() { cntlm -c ~/cntlm/cntlm.conf -I -v; }

edit-brew() { pushd "$PACKAGE_DIR" >/dev/null && editor ./Brewfile && popd >/dev/null; }

find_mail_spammer() {
  local db="$HOME/Library/Mail/V10/MailData/Envelope Index"
  sqlite3 -readonly "$db" <<'EOF'
.mode column
.headers on
.width 40 25 8
SELECT a.address AS sender, a.comment AS name, COUNT(*) AS count
FROM messages m
JOIN addresses a ON m.sender = a.ROWID
GROUP BY a.address, a.comment
ORDER BY count DESC
LIMIT 10;
EOF
}
