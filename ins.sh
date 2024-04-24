#!/bin/bash

DIR="$HOME/exper/.dotfiles"

#specify ignore-files
#temp: -o -name "*.*" \
dotfiles=( $(find ${DIR} -maxdepth 1 ! \( \
	-name "bin" \
	-o -name ".git" \
	-o -name ".gitignore" \
\)))

#confirm existence: $DIR
if [ ! -d "$DIR" ]; then
	echo "Error: $DIR doesn't exist." >&2
	exit 1
fi

unset 'dotfiles[0]'

#delete duplicate files and create links
for dotfile in ${dotfiles[@]};do
	if [ -e "$DIR/../$(basename $dotfile)" ]; then
		rm -r $DIR/../$(basename $dotfile)
	fi
	ln -snf $dotfile ${DIR}/.. 
done
