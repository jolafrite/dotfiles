#!/usr/bin/env zsh

cheat() {
  curl -s "cheat.sh/$1";
}

# Move files fuzzy find destination
fmv() {
  mv "$@" $(fd -t d -H | fzf)
}

# Show package.json scripts with fzf and run selected
pkgrun() {
  name=$(jq .scripts package.json | sed '1d;$d' | fzf --height 40% | awk -F ': ' '{gsub(/"/, "", $1); print $1}')
  if [[ -n $scripts ]]; then
    yarn run "$name"
  fi
}

# Jump to folder (zoxide) and open nvim.
zv() {
 __zoxide "$1" && nvim .
}

# Retrieve process real memory
psrm() {
  ps -o rss= -p "$1" | awk '{ hr=$1/1024; printf "%13.2f Mb\n",hr }' | tr -d ' ';
}

epoch() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    date --date "@$1" +"+%Y-%m-%dT%H:%M:%SZ"
  else
    date -r "$1" '+%Y-%m-%dT%H:%M:%SZ'
  fi
}

# Watch process real memory
psrml() {
  while true;
  do
    psrm "$1";
    sleep 1;
  done
}

# Run jq using fzf and clipboard as source
ijq() {
  echo '' | fzf --print-query --preview-window nohidden --no-height --preview "${1-pbpaste} | jq {q}"
}

# Go to repository root folder
groot() {
  root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -n "$root" ]; then
    cd "$root";
  else
    echo "Not in a git repository"
  fi
}

# Print all 256 ANSI colors
ansi_colors() {
  python3 -c "print(''.join(f'\u001b[48;5;{s}m{s.rjust(4)}' + ('\n' if not (int(s)+1) % 8 else '') for s in (str(i) for i in range(256))) + '\u001b[0m')"
}

# Fzf all folders and cd on selection
cdi() {
  p="$(fd -t d -H | fzf)"
  if [ -n "$p" ]; then
    cd "$p"
  fi
}

# Compare json files
jcmp() {
  delta <(jq --sort-keys . $1) <(jq --sort-keys . $2)
}

# Pack a folder into a .tar.bz2
pack() {
  if [ -z "$1" ]; then
    echo "No directory supplied. \nUsage: $funcstack[1] directory-path"
  elif ! [[ -d $1 ]]; then
    echo "Error: $1 is not a directory."
  else
    tar -cvjSf "$(date "+%F")-$1.tar.bz2" "$1"
  fi
}

# Unpack a .tar.bz2 folder
unpack() {
  if [ -z "$1" ]; then
    echo "No directory supplied. \nUsage: $funcstack[1] directory-path.tar.bz2"
  else
    tar xjf "$1"
  fi
}

brewit() {
  brew update &&
    brew upgrade &&
    brew autoremove &&
    brew cleanup -s &&
    brew doctor
}

dstop-all() {
  docker stop $(docker ps -aq)
}

drm-all() {
  docker rm $(docker ps -aq)
}

alias l="ll"
alias vi="nvim"
alias vim="nvim"
alias cat="bat -p --paging=never --theme='TwoDark'"
alias dc="docker compose"
alias dot="cd ~/.dotfiles && nvim ."
alias e="nvim"
alias icat="wezterm imgcat"
alias lt="dust -b -H -r -X '.git'"
alias tree="exa --tree --level=5 --icons --group-directories-first --color auto"
# Create 5 random passwords
alias mkpwd="xkcdpass --count=5 --acrostic=\"chaos\" -C \"first\" -R --min=5 --max=6 -D \"#@^&~_-;\""
alias isodate='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias zshre="nvim ~/.dotfiles/stow/zsh/.zshrc"
alias zshee="nvim ~/.dotfiles/stow/zsh/.zshenv"
# Reload shell
alias reload="exec $SHELL -l"
# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
alias localip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\  -f2"
# Lock the screen
alias afk="pmset displaysleepnow"
alias rmf="rm -rf"
