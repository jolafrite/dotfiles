export HOMEBREW_NO_ANALYTICS=1

havecmd "brew" || {
	PATH="${HOMEBREW_HOME}/bin:$PATH"
	eval "$(${HOMEBREW_HOME}/bin/brew shellenv)"
}

PATH="\
${HOME}/.local/bin:\
/usr/local/bin:\
${PATH}"

export PATH

# reset $PWD to $HOME since sometimes starts in at '/'
cd

# check if supervisord (background processes are running)
# else start them
#
# this does mean processes don't start running till
# I open a terminal, but I start one on boot anyways

if [[ ! -e /tmp/supervisord.pid ]]; then
	echo "Supervisor pid file does not exist, starting supervisor..."
	super --daemon
fi
