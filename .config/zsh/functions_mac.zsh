#!/usr/bin/env zsh
show-fps() { /bin/launchctl setenv MTL_HUD_ENABLED 1; }
hide-fps() { /bin/launchctl setenv MTL_HUD_ENABLED 0; }
proxy-start() { cntlm -c ~/cntlm/cntlm.conf -I -v; }
edit-brew() { pushd "$PACKAGE_DIR"; editor ./Brewfile; popd; }
tmux-which-key() { tmux show-wk-menu-root; }