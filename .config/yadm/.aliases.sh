#!/usr/bin/env bash
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias afk="pmset displaysleepnow"
alias cat="bat -p --paging=never --theme='TwoDark'"
alias dc="docker compose"
alias diff="batdiff"
alias dot="\$EDITOR ~/.config/nvim/"
alias e="nvim"
alias icat="wezterm imgcat"
alias isodate='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias l="ll"
alias ll="exa --group-directories-first -l --color always --icons -a -s type"
alias localip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\  -f2"
alias ls="exa --group-directories-first -G  --color auto --icons -a -s type"
alias lt="dust -b -H -r -X '.git'"
alias mkcd='foo(){ mkdir -p "$1"; cd "$1" }; foo'
alias mkpwd="xkcdpass --count=5 --acrostic=\"chaos\" -C \"first\" -R --min=5 --max=6 -D \"#@^&~_-;\""
alias path='echo -e ${PATH//:/\\n}'
alias reload="exec $SHELL -l"
alias rmf="rm -rf"
alias tree="exa --tree --level=5 --icons --group-directories-first --color auto"
alias vi="nvim"
alias vim="nvim"
alias zshee="\$EDITOR ~/.zshenv"
alias zshre="\$EDITOR ~/.zshrc"

# Include custom aliases
if [[ -f ~/.aliases.local ]]; then
  source ~/.aliases.local
fi
