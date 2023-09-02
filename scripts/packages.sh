taps=(
	homebrew/cask
	homebrew/cask-fonts
	# popcorn-official/popcorn-desktop
)

packages=(
	bat
	bandwhich
	bottom
	btop
	curl
	dooit
	exa
	fd
	fzf
	gdu
	gh
	git
	git-delta
	glow
	gh
	hyperfine
	jenv
	fnm
	jq
	lazydocker
	lazygit
	lolcat
	neovim
	nmap
	openjdk
	python3
	ripgrep
	rustup
	shellcheck
	stow
	taskell
	telnet
	tmux
	trash-cli
	tz
	xo/xo/usql
	viddy
	watson
	websocat
	wget
	wifi-password
	zellij
	zsh
	zsh-autosuggestions
	zsh-syntax-highlighting
	zoxide
)

install_packages() {
	info "Configuring taps"
	apply_brew_taps "${taps[@]}"

	info "Installing packages..."
	install_brew_formulas "${packages[@]}"

	info "Cleaning up brew packages..."
	brew cleanup
}

post_install_packages() {
	info "Installing fzf bindings"
	# shellcheck disable=SC2046
	$(brew --prefix)/opt/fzf/install
}
