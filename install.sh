#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

. scripts/apps.sh
. scripts/brew.sh
. scripts/cli.sh
. scripts/config.sh
. scripts/fonts.sh
. scripts/osx.sh
. scripts/packages.sh
. scripts/utils.sh

cleanup() {
	err "Last command failed"
	info "Finishing..."
}

wait_input() {
	read -r -p "Press enter to continue:"
}

main() {
	info "Installing..."

	info "################################################################################"
	info "Homebrew Packages"
	info "################################################################################"
	wait_input
	install_packages
	post_install_packages
	success "Finished installing Homebrew packages"

	info "################################################################################"
	info "MacOS Apps"
	info "################################################################################"
	wait_input
	install_macos_apps
	install_masApps
	success "Finished installing macOS apps"

	info "################################################################################"
	info "Homebrew Fonts"
	info "################################################################################"
	wait_input
	install_fonts
	success "Finished installing fonts"

	info "################################################################################"
	info "PiP modules"
	info "################################################################################"
	wait_input
	install_python_packages
	success "Finished installing python packages"

	info "################################################################################"
	info "Nodejs tools"
	info "################################################################################"
	wait_input
	install_nodejs
	success "Finished installing nodejs tools"

	info "################################################################################"
	info "Go tools"
	info "################################################################################"
	wait_input
	install_go
	success "Finished installing Go tools"

	info "################################################################################"
	info "Rust tools"
	info "################################################################################"
	wait_input
	install_rust
	success "Finished installing Rust tools"

	info "################################################################################"
	info "Configuration"
	info "################################################################################"
	wait_input
	setup_osx
	success "Finished configuring MacOS defaults. NOTE: A restart is needed"
	stow_dotfiles
	success "Finished stowing dotfiles"

	info "################################################################################"
	info "Creating development folders"
	info "################################################################################"
	mkdir -p ~/Development/projects

	success "Done"

	info "System needs to restart. Restart?"

	select yn in "y" "n"; do
		case $yn in
		y)
			sudo shutdown -r now
			break
			;;
		n) exit ;;
		esac
	done
}

trap cleanup SIGINT SIGTERM ERR EXIT

main
