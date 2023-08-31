#!/usr/bin/env bash

apps=(
	arctype
	avast-security
	brave-browser
	bitwarden
	clipy
	deepl
	docker
	expressvpn
	fig
	firefox
	google-chrome
	nvidia-geforce-now
	popcorn-time
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
