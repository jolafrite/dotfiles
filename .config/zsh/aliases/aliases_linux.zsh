#!/bin/zsh

alias brave="xdg-open https://brave.com"
alias calc="gnome-calculator 2>/dev/null || kcalc 2>/dev/null || echo 'no calculator found'"
alias docker-app="docker desktop 2>/dev/null || echo 'Docker Desktop not installed'"
alias excel="xdg-open /usr/lib/libreoffice/program/soffice 2>/dev/null || echo 'LibreOffice not installed'"
alias postman="flatpak run com.postman.Postman 2>/dev/null || xdg-open /usr/bin/postman 2>/dev/null || echo 'Postman not installed'"
alias slack="flatpak run com.slack.Slack 2>/dev/null || xdg-open /usr/bin/slack 2>/dev/null || echo 'Slack not installed'"
alias teams="flatpak run com.microsoft.Teams 2>/dev/null || xdg-open /usr/bin/teams 2>/dev/null || echo 'Teams not installed'"
alias webtorrent="flatpak run org.webtorrent.WebTorrent 2>/dev/null || echo 'WebTorrent not installed'"
alias zoom="flatpak run us.zoom_meetings 2>/dev/null || xdg-open /usr/bin/zoom 2>/dev/null || echo 'Zoom not installed'"
alias idea="flatpak run org.jetbrains.IntelliJ-IDEA 2>/dev/null || xdg-open /usr/bin/idea 2>/dev/null || echo 'IntelliJ not installed'"
alias en0="ip -br addr show | awk '{print \$1, \$4}'"
alias spotlight="fd --type f"
alias ub="update-apt"

trash() { command mv "$@" ~/.local/share/Trash; }

