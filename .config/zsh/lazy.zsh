#!/usr/bin/env zsh

fuck() {
	eval $(thefuck --alias)
	fuck "$@"
}
