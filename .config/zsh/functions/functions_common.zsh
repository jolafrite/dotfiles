#!/usr/bin/env zsh

cheat() { curl -s "cheat.sh/$1"; }

ansi-colors() {
  python3 -c "print(''.join(f'\u001b[48;5;{s}m{s.rjust(4)}' + ('\n' if not (int(s)+1) % 8 else '') for s in (str(i) for i in range(256))) + '\u001b[0m')"
}

pack() {
  if [[ -z "$1" ]]; then
    print "No directory supplied.\nUsage: pack <directory>"
  elif ! [[ -d "$1" ]]; then
    print "Error: $1 is not a directory."
  else
    tar -cvjSf "$(date "+%F")-$1.tar.bz2" "$1"
  fi
}

unpack() {
  if [[ -z "$1" ]]; then
    print "No file supplied.\nUsage: unpack <file.tar.bz2>"
  else
    tar xjf "$1"
  fi
}

dstop-all() { docker stop $(docker ps -aq); }
drm-all() { docker rm $(docker ps -aq); }

gwti() {
  git clone --bare "$1" .bare
  echo "gitdir: ./.bare" > .git
  echo "  fetch = +refs/heads/*:refs/remotes/origin/*" >> .bare/config
}

is_machine() {
  case "$(uname -s)" in
    Darwin) [[ "$1" == "mac" ]] && return 0 ;;
    Linux)  [[ "$1" == "linux" ]] && return 0 ;;
    *)      return 1 ;;
  esac
  return 1
}

havecmd() { type "$1" &>/dev/null; }

tmux-which-key() { tmux show-wk-menu-root; }
