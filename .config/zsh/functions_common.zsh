#!/usr/bin/env zsh
cheat() { curl -s "cheat.sh/$1"; }
fmv() { mv "$@" $(fd -t d -H | fzf); }
zv() { __zoxide "$1" && nvim .; }
psrm() { ps -o rss= -p "$1" | awk '{ hr=$1/1024; printf "%13.2f Mb\n",hr }' | tr -d ' '; }
epoch() { if [[ "$OSTYPE" == "linux-gnu"* ]]; then date --date "@$1" "+%Y-%m-%dT%H:%M:%SZ"; else date -r "$1" '+%Y-%m-%dT%H:%M:%SZ'; fi; }
psrml() { while true; do psrm "$1"; sleep 1; done; }
ijq() { echo '' | fzf --print-query --preview-window nohidden --no-height --preview "${1-pbpaste} | jq {q}"; }
jcmt() { delta <(jq --sort-keys . "$1") <(jq --sort-keys . "$2"); }
groot() { root="$(git rev-parse --show-toplevel 2>/dev/null)"; if [ -n "$root" ]; then cd "$root"; else echo "Not in a git repository"; fi; }
ansi-colors() { python3 -c "print(''.join(f'\u001b[48;5;{s}m{s.rjust(4)}' + ('\n' if not (int(s)+1) % 8 else '') for s in (str(i) for i in range(256))) + '\u001b[0m')"; }
cdi() { p="$(fd -t d -H | fzf)"; if [ -n "$p" ]; then cd "$p"; fi; }
pack() { if [ -z "$1" ]; then echo "No directory supplied"; elif ! [[ -d $1 ]]; then echo "Error: $1 is not a directory."; else tar -cvjSf "$(date "+%F")-$1.tar.bz2" "$1"; fi; }
unpack() { if [ -z "$1" ]; then echo "No directory supplied"; else tar xjf "$1"; fi; }
dstop-all() { docker stop $(docker ps -aq); }
drm-all() { docker rm $(docker ps -aq); }
gwti() { git clone --bar "$1" .bare; echo "gitdir: ./.bare" >.git; echo "  fetch = +refs/heads/*:refs/remotes/origin/*" >>.bare/config; }
reload() { exec $SHELL -l; }
nvim-clear-cache() { rm -rf "$XDG_DATA_HOME/nvim" "${XDG_STATE_HOME}/nvim" "${XDG_CACHE_HOME}/nvim"; }
edit-config() { pushd "$XDG_CONFIG_HOME"; editor .; popd; }
edit-nvim() { pushd "$NVIM_DIR"; editor .; popd; }
edit-starship() { pushd "$XDG_CONFIG_HOME"; editor ./starship.toml; popd; }
edit-yadm() { pushd "$YADM_DIR"; editor .; popd; }
edit-zsh() { pushd "$ZDOTDIR"; editor .; popd; }
edit-aliases() { pushd "$ALIAS_DIR"; editor .; popd; }
is_machine() { case "$(uname -s)" in Darwin) [[ "$1" == "mac" ]] && return 0 ;; Linux) [[ "$1" == "linux" ]] && return 0 ;; *) return 1 ;; esac; return 1; }
havecmd() { type "$1" &>/dev/null; }