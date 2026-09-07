#!/usr/bin/env zsh
edit-brew() { pushd "$PACKAGE_DIR"; editor ./linux_packages.txt; popd; }
tmux-which-key() { tmux show-wk-menu-root; }