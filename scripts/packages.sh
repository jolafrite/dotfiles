taps=(
	homebrew/cask
	homebrew/cask-fonts
	# popcorn-official/popcorn-desktop
)

packages=(
	bandwhich
	bash
	bat
	bottom
	btop
	curl
	exa
	fd
	fzf
	g
	gdu
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
	mas
	neovim
	nmap
	openjdk
	parallel
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
	#xo/xo/usql
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
