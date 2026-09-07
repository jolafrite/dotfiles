# Linux-specific shell configuration
PATH="\
$HOME/.local/bin:\
$HOME/.local/share/pnpm:\
$HOME/.local/share/go/bin:\
$HOME/.local/share/cargo/bin:\
$XDG_DATA_HOME/atuin/bin:\
$XDG_DATA_HOME/zoxide/bin:\
$PATH"
export PATH

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export GOBIN="$XDG_DATA_HOME/go/bin"
export GOPATH="$XDG_DATA_HOME/go"

[ -d "$XDG_DATA_HOME/pyenv" ] && {
  export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
  export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
}

export NVM_DIR="$XDG_DATA_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

havecmd zoxide && eval "$(zoxide init zsh)"
havecmd atuin && eval "$(atuin init zsh)"

havecmd fzf && {
  [ -f "$HOME/.local/share/fzf/completion.zsh" ] && source "$HOME/.local/share/fzf/completion.zsh" 2>/dev/null
  [ -f "$HOME/.local/share/fzf/key-bindings.zsh" ] && source "$HOME/.local/share/fzf/key-bindings.zsh" 2>/dev/null
}

[ -f "$XDG_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$XDG_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$XDG_DATA_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$XDG_DATA_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

havecmd jj && source <(COMPLETE=zsh jj 2>/dev/null)
[ -f "$HOME/.g/env" ] && . "$HOME/.g/env"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in *":$PNPM_HOME:"*) ;; *) export PATH="$PNPM_HOME:$PATH" ;; esac

if [[ ! -e /tmp/supervisord.pid ]]; then
  echo "Starting supervisor..."
  super --daemon 2>/dev/null || true
fi