#!/bin/bash
##
# Written by Amin El-Naggar @vvMINOvv on some midnight...
# #
# Argument = -f force_rewrite -d delete -p path

usage() {
cat << EOF >&2
usage: $0 options

This script will symlink all the dot files to ~:
	.bashrc
	.bash_profile
	.path
	.bash_prompt
	.exports
	.aliases
	.functions
	.extra
	.osx

OPTIONS:
	-h		Show this message
	-f		Force replace .dotfiles if they already exist in ~
	-d		Only deletes .dotfiles from ~
	-p		Path of .dotfiles if not ~
EOF
}

ifNotYexit(){
	read -p "Are you sure? (y/n) " -n 1
	echo
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo Cancelling
		exit 0
	fi
}

dotFilesPath=$HOME/

delete=false
forceCreate=""
while getopts “:hcdfp:” OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		d)
			echo "This will delete the dotfiles in your directory."
			ifNotYexit
			echo "Deleting..."
			delete=true
			;;
		f)
			echo "This may overwrite existing files in your directory."
			ifNotYexit
			forceCreate="f"
			;;
		p)
			dotFilesPath=$OPTARG
			;;
		\?)
			usage
			exit
			;;
	esac
done


files=( .bashrc .bash_profile .path .bash_prompt .exports .aliases .functions .extra .osx )

if $delete ; then
	for file in "${files[@]}"; do
		find $dotFilesPath$file -type l -exec unlink {} \;
	done
	unset file
else
	echo "Creating Symlinks in $dotFilesPath"
	for file in "${files[@]}"; do
		ln -s$forceCreate `pwd`/source/$file $dotFilesPath$file
	done
	unset file
fi

