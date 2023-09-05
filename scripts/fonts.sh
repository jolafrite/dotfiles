#!/usr/bin/env bash

fonts=(
	font-fira-code-nerd-font
)

install_fonts() {
	info "Installing fonts..."
	brew tap homebrew/cask-fonts
	install_brew_casks "${fonts[@]}"
}
