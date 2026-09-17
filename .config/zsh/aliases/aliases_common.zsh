#!/usr/bin/env zsh

is_macos() {
[[ "$OSTYPE" == "darwin"* ]];
}
is_linux() {
[[ "$OSTYPE" == "linux-gnu"* ]];
}

if [[ -t 1 ]]; then
  RED=$(tput setaf 1)
  GREEN=$(tput setaf 2)
  BLUE=$(tput setaf 4)
  NC=$(tput sgr0)
else
  RED=""; GREEN=""; BLUE=""; NC=""
fi


alias c="clear"
alias x="exit"
alias re="reload"
alias p="pwd"
alias h="history"
alias j="jobs -l"

reload() {
exec "${SHELL:-zsh}" -l;
}
alias path='print -l ${PATH//:/\\n}'

mcd() {
mkdir -p "$1" && cd "$1" || return;
}

groot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$root" ]]; then
    cd "$root" || return
  else
    print "${RED}Not in a git repository${NC}"
  fi
}

zv() {
z "$1" && nvim .;
}

cdi() {
  local dir
  dir=$(fd -t d -H | fzf)
  [[ -n "$dir" ]] && cd "$dir" || return
}


alias eza-defaults="eza --git --octal-permissions --header --group-directories-first"
alias ll="eza-defaults --icons --long"
alias la="ll --all"
alias tree="eza --tree --level=5 --icons --group-directories-first --color auto"
command -v eza >/dev/null || alias ll="command ls -lh"

ff() {
find . -name "$1";
}
ffs() {
find . -name "*$1*";
}
ffe() {
find . -name "*$1";
}

fmv() {
  local target
  target=$(fd -t d -H | fzf)
  [[ -n "$target" ]] && mv "$@" "$target" || return
}

extract() {
  [[ -z "$1" ]] && {
print "Usage: extract <file>"; return 1;
}
  [[ ! -f "$1" ]] && {
print "'$1' is not a valid file"; return 1;
}
  case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar e "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         print "'$1' cannot be extracted via extract()"; return 1 ;;
  esac
}

alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"
alias numFiles='print $(ls -1 | wc -l)'
alias now='date +"%A %Y-%m-%d %T %p %s"'
alias fix_stty="stty sane"


alias pubip="curl -s ipinfo.io | jq -r .ip"
alias ipinfo="curl -s ipinfo.io"
alias wanip4="dig @resolver1.opendns.com ANY myip.opendns.com +short"
alias wanip6="dig @resolver1.opendns.com AAAA myip.opendns.com +short -6"

alias o='xdg-open . 2>/dev/null || open .'

alias listening="lsof -nP +c 15 | grep LISTEN"
alias ports="lsof -i -n -P | grep TCP"
alias findPid="lsof -t -c"

psrm() {
ps -o rss= -p "$1" | awk '{
hr=$1/1024; printf "%13.2f Mb\n", hr
}' | tr -d ' ';
}
psrml() {
while true; do psrm "$1"; sleep 1; done;
}

epoch() {
  if is_linux; then
    date --date "@$1" "+%Y-%m-%dT%H:%M:%SZ"
  else
    date -r "$1" '+%Y-%m-%dT%H:%M:%SZ'
  fi
}

ii() {
  print "\n${RED}You are logged on ${NC}$HOST"
  print "\n${RED}Additional information:${NC}"
  uname -a
  print "\n${RED}Users logged on:${NC}"
  w -h
  print "\n${RED}Current date:${NC}"
  date
  print "\n${RED}Machine stats:${NC}"
  uptime
  print "\n${RED}Public facing IP Address:${NC}"
  pubip
  print ""
}


alias gC="git clone"
alias gP="git pull"
alias gst="git status"
alias gsk="gpg --list-secret-keys --keyid-format LONG"

gas() {
git status; git add . -A; git commit -m "$1"; git push;
}
gsa() {
git stash save "$1" -a; git stash list;
}

alias yA="yadm add --all"
alias ya="yadm add"
alias yc="yadm commit"
ycp() {
if (( $# == 0 )); then yadm commit && yadm push; else yadm commit -m "$*" && yadm push; fi;
}
alias yd="yadm diff"
ydh() {
yadm diff HEAD~"${1:-1}";
}
alias yds="yadm diff --staged"
alias yl="yadm pull --recurse-submodules"
alias yP="yadm pull"
alias yp="yadm push"
alias yrh="yadm reset"
alias yrhh="yadm reset --hard"
alias yst="yadm status"
alias ysu="yadm status -u"
alias ylols="yadm log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"

feature_branch() {
  local main_branch="main"
  local prefix="feature"
  local today=$(date +%Y-%m-%d)
  local username=$(echo "$USER" | tr '[:upper:]' '[:lower:]')
  local additional_path=$(echo "$*" | tr ' ' '-')
  local index=1
  local branch_path="${prefix}/${username}"

  [[ -n "$additional_path" ]] && branch_path="${branch_path}/${additional_path}"
  branch_path="${branch_path}/${today}"

  if [[ "$(git branch --show-current)" != "$main_branch" ]]; then
    print "Switching to ${main_branch} and pulling latest changes..."
    git checkout "$main_branch" && git pull
  fi

  while git rev-parse --verify --quiet "${branch_path}/${index}" >/dev/null 2>&1; do
    ((index++))
  done

  local new_branch="${branch_path}/${index}"
  print "Creating and checking out ${new_branch}..."
  git checkout -b "$new_branch"
}
alias fb="feature_branch"


alias k="kubectl"
alias kall='k get all -o wide --show-labels'
alias kc='k config get-contexts'
alias kn='k config set-context --current --namespace'
kd() {
kubectl "$@" -o yaml --dry-run=client;
}

alias db="docker build -f"
alias awsregion="aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'"

alias cr="cargo run --verbose"
alias vbc="source venv/bin/activate"
alias vde="deactivate"
alias ven="virtualenv venv"

bi() {
  if is_macos; then
    brew install "$@"
  elif is_linux; then
    if command -v apt >/dev/null; then
      sudo apt install "$@"
    elif command -v dnf >/dev/null; then
      sudo dnf install "$@"
    else
      print "${RED}Unsupported package manager${NC}"
      return 1
    fi
  fi
}

pkgrun() {
  if [[ ! -f "package.json" ]]; then
    print "${RED}No package.json found${NC}"
    return 1
  fi
  local name
  name=$(jq -r '.scripts | keys[]' package.json 2>/dev/null | fzf --height 40%)
  if [[ -n "$name" ]]; then
    npm run "$name"
  fi
}


: "${EDITOR:=nvim}"
alias e="$EDITOR"

edit-config() {
pushd "$XDG_CONFIG_HOME" >/dev/null && $EDITOR . && popd >/dev/null;
}
edit-nvim() {
pushd "${NVIM_DIR:-$XDG_CONFIG_HOME/nvim}" >/dev/null && $EDITOR . && popd >/dev/null;
}
edit-starship() {
pushd "$XDG_CONFIG_HOME" >/dev/null && $EDITOR ./starship.toml && popd >/dev/null;
}
edit-yadm() {
pushd "${YADM_DIR:-$HOME/.yadm}" >/dev/null && $EDITOR . && popd >/dev/null;
}
edit-zsh() {
pushd "${ZDOTDIR:-$HOME}" >/dev/null && $EDITOR . && popd >/dev/null;
}
edit-aliases() {
pushd "${ALIAS_DIR:-$XDG_CONFIG_HOME/zsh/aliases}" >/dev/null && $EDITOR . && popd >/dev/null;
}

alias ea="edit-aliases"
alias en="edit-nvim"
alias es="edit-starship"
alias ey="edit-yadm"
alias ez="edit-zsh"
alias keys="catn ${ALIAS_DIR:-$XDG_CONFIG_HOME/zsh/aliases}/aliases_common"
alias nvim-clear-cache="rm -rf ${XDG_DATA_HOME:-~/.local/share}/nvim ${XDG_STATE_HOME:-~/.local/state}/nvim ${XDG_CACHE_HOME:-~/.cache}/nvim"


alias catn="grep -Ev '^(#|$)'"
zipf() {
zip -r "$1.zip" "$1";
}
alias editHosts="sudo $EDITOR /etc/hosts"
alias killall-nvim="killall -9 nvim"

httpDebug() {
curl "$@" -o /dev/null -w "dns: %{time_namelookup} | connect: %{time_connect} | pretransfer: %{time_pretransfer} | starttransfer: %{time_starttransfer} | total: %{time_total}\n";
}
httpHeaders() {
curl -I -L "$@";
}

ijq() {
print "" | fzf --print-query --preview-window nohidden --no-height --preview "${1:-pbpaste} | jq {q}";
}
jcmt() {
delta <(jq --sort-keys . "$1") <(jq --sort-keys . "$2");
}

alias ua="update-all"
alias uc="update-cargo"
alias ug="update-golang"
alias un="update-node"
alias uv="update-nvim"
