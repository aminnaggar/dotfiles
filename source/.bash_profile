##############
##--------Source all dotfiles
##############
	# Load the shell dotfiles, and then some:
	# * ~/.path can be used to extend `$PATH`.
	# * ~/.extra can be used for other settings you don’t want to commit.
	for file in ~/.{extra,path,bash_prompt,exports,aliases,functions}; do
		[ -r "$file" ] && source "$file"
	done
	unset file

##############
##--------History
##############

	# timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
	export HISTTIMEFORMAT='%F %T '

	# keep history up to date, across sessions, in realtime
	#  http://unix.stackexchange.com/a/48113
	export HISTCONTROL=ignoredups:erasedups:ignorespace         # no duplicate entries, ommit space prefixed commands
	export HISTSIZE=100000                          # big big history (default is 500)
	export HISTFILESIZE=$HISTSIZE                   # big big history
	which shopt > /dev/null && shopt -s histappend  # append to history, don't overwrite it

	# Save and reload the history after each command finishes
	export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

	# ^ the only downside with this is [up] on the readline will go over all history not just this bash session.

	# Keeps history clean, by not saving pwd,ls,clear....
	export HISTIGNORE="ls:la:cd:cd -:pwd:cls:exit:date:* --help"
	export HISTCONTROL=ignorespace:ignoredups

##############
##--------Hooking in other apps…
##############
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

	# Load RVM into a shell session *as a function*
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

	# z beats cd most of the time.
	#   github.com/rupa/z
	[ -f ~/code/z/z.sh ] && source ~/code/z/z.sh

	[ -f ~/.fzf.bash ] && source ~/.fzf.bash

##############
##--------Completion
##############
	if [[ -n "$ZSH_VERSION" ]]; then  # quit now if in zsh
	    return 1 2> /dev/null || exit 1;
	fi;

	# bash completion.
	if  which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	    source "$(brew --prefix)/share/bash-completion/bash_completion";
	elif [ -f /etc/bash_completion ]; then
	    source /etc/bash_completion;
	fi;

	# homebrew completion
	if  which brew > /dev/null; then
	    source `brew --repository`/Library/Contributions/brew_bash_completion.sh
	fi;

	# Enable tab completion for `g` by marking it as an alias for `git`
	if type __git_complete &> /dev/null; then
	    __git_complete g __git_main
	fi;

	# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
	[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

	# Add tab completion for `defaults read|write NSGlobalDomain`
	# You could just use `-g` instead, but I like being explicit
	complete -W "NSGlobalDomain" defaults

	# If possible, add tab completion for many more commands
	[ -f /etc/bash_completion ] && source /etc/bash_completion

	# cycle through Tabbed results
	# other options: complete
	bind TAB:menu-complete

	# run the git completeion script
	if [ -f ~/.git-completion.bash ]; then
	  . ~/.git-completion.bash
	fi


##############
##--------MISC
##############
	# to help sublimelinter etc with finding my PATHS
	case $- in
	   *i*) source ~/.extra
	esac

	# generic colouriser
	GRC=`which grc`
	if [ "$TERM" != dumb ] && [ -n "$GRC" ]
	    then
	        alias colourify="$GRC -es --colour=auto"
	        alias configure='colourify ./configure'
	        for app in {diff,make,gcc,g++,ping,traceroute}; do
	            alias "$app"='colourify '$app
	    done
	fi

##############
##--------Globbing
##############

	# Add tab completion for `defaults read|write NSGlobalDomain`
	# You could just use `-g` instead, but I like being explicit
	# complete -W "NSGlobalDomain" defaults

	# Enable some Bash 4 features when possible:
	# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
	# * Recursive globbing, e.g. `echo **/*.txt`
	for option in autocd globstar; do
		shopt -s "$option" 2> /dev/null
	done

	# Case-insensitive globbing (used in pathname expansion)
	shopt -s nocaseglob

	# Autocorrect typos in path names when using `cd`
	shopt -s cdspell
