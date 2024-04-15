export HOMEBREW_NO_ANALYTICS=1

PATH="\
$HOMEBREW_HOME/bin:\
$HOMEBREW_HOME/sbin:\
$HOME/.local/bin:\
$HOME/Applications/WezTerm.app/Contents/MacOS:\
/usr/local/bin:\
$PATH"
export PATH

export LIBSQLITE="$HOMEBREW_HOME/opt/sqlite/lib/libsqlite3.dylib"

# reset $PWD to $HOME since sometimes starts in at '/'
cd

havecmd "brew" || {
	eval "$(${HOMEBREW_HOME}/bin/brew shellenv)"
}

havecmd "zoxide" && {
  eval "$(zoxide init zsh)"
}

if [ -f "$HOME/.g/env" ]; then
    . "$HOME/.g/env"
fi

eval "$(atuin init zsh)"

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && {
  source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
}
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "zap-zsh/exa"
plug "zap-zsh/fnm"
plug "chivalryq/git-alias"
plug "z-shell/zsh-zoxide"
plug "Freed-Wu/fzf-tab-source"
plug "zap-zsh/fzf"
plug "Aloxaf/fzf-tab"
plug "MichaelAquilina/zsh-you-should-use"
plug "wintermi/zsh-brew"
plug "wintermi/zsh-golang"
plug "wintermi/zsh-rust"

# Load and initialise completion system
autoload -Uz compinit
compinit

[[ $- == *i* ]] && source_if_exists "$HOMEBREW_HOME/opt/fzf/shell/completion.zsh" 2>/dev/null
source_if_exists "$HOMEBREW_HOME/opt/fzf/shell/key-bindings.zsh"
source_if_exists "$HOMEBREW_HOME/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if_exists "$HOMEBREW_HOME/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source_if_exists "$HOMEBREW_HOME/opt/git-extras/share/git-extras/git-extras-completion.zsh"
source_if_exists "$XDG_DATA_HOME/functions/_atuin"
source_if_exists "$HOME/Applications/WezTerm.app/Contents/Resources/shell-completion/zsh"

# check if supervisord (background processes are running)
# else start them
#
# this does mean processes don't start running till
# I open a terminal, but I start one on boot anyways

if [[ ! -e /tmp/supervisord.pid ]]; then
	echo "Supervisor pid file does not exist, starting supervisor..."
	super --daemon
fi
