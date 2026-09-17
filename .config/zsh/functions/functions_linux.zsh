#!/usr/bin/env zsh

edit-linux-packages() { 
    pushd "$PACKAGE_DIR" >/dev/null && \
    editor ./linux_packages.txt && \
    popd >/dev/null;
}
