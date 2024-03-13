#!/bin/sh
# variables which ideally should be sourced into the global
# environment since they could be referenced without opening a terminal
# e.g. from my menu bar/window manager/run launcher

# helper envvar to be used in names of files
SHELL_BOOT_TIME="$(date '+%s')"
export SHELL_BOOT_TIME

TTT_DATADIR="${XDG_DATA_HOME}/ttt"
export TTT_HISTFILE="${TTT_DATADIR}/${SHELL_BOOT_TIME}.csv"
if [ ! -d "$TTT_DATADIR" ]; then
	mkdir -p "$TTT_DATADIR"
fi

export NVIM_SPELLFILE="${XDG_DOCUMENTS_DIR}/.nvim_spelldir/en.utf-8.add"
