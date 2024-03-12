# under certain (interactive, basic) conditions, upgrade a command
# to a fancy version

# if I type python with out any arguments, launch ipython instead
python() {
	python3 "$@"
}
python3() {
	if (($# == 0)); then
		echo -e "$(tput setaf 2)Launching ipython instead...$(tput sgr0)"
		ipython
	else
		command python3 "$@"
	fi
}

man() {
	if [[ -z "$1" ]]; then
		macho
	else
		command man "$@"
	fi
}
