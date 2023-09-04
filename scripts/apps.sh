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

mas_apps=(
	"937984704"   # Amphetamine
	"1444383602"  # Good Notes 5
  	"1352778147"  # Bitwarden
)

install_macos_apps() {
	info "Installing macOS apps..."
	install_brew_casks "${apps[@]}"
}

install_masApps() {
	info "Installing App Store apps..."
	for app in "${mas_apps[@]}"; do
		mas install "$app"
	done
}
