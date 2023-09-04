#!/usr/bin/env bash

apps=(
	arctype
	brave-browser
	clipy
	deepl
	docker
	expressvpn
	nvidia-geforce-now
	# popcorn-time
	postman
	rectangle
	tableplus
	the-unarchiver
	vlc
	webtorrent
	wez/wezterm/wezterm
	zoom
)

install_macos_apps() {
	info "Installing macOS apps..."
	install_brew_casks "${apps[@]}"
}
