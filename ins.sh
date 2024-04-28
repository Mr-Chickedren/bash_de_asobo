#!/bin/bash

EVACUATION=".___EVACU___"

#specify ignore-files
#temp: -o -name "*.*" \
dotfiles=( $(find $HOME/.dotfiles -maxdepth 1 ! \( \
	-name "bin" \
	-o -name ".git" \
	-o -name ".gitignore" \
\)))

#confirm existence: .dotfiles
if [ ! -d "$HOME/.dotfiles" ]; then
	echo "Error: $HOME/.dotfiles doesn't exist." >&2
	exit 1
fi

unset 'dotfiles[0]'
echo "Apply dotfiles."

#confirm existence: $EVACUATION
if [ -d "$HOME/$EVACUATION" ]; then
	echo "Confirm: $HOME/$EVACUATION have already existed."
	echo "Do you want to use this as is? (or clean)"
	while :
	do
		read -p "[y/n]:" ans
		if [ "$ans" == "y" ]; then break
		elif [ "$ans" == "n" ]; then 
			rm -r $HOME/$EVACUATION
			echo "Cleaned."
			mkdir $HOME/$EVACUATION
			break
		else continue
		fi
	done
else
	mkdir $HOME/$EVACUATION
fi

#move duplicate files and create links
for dotfile in ${dotfiles[@]};do
	if [ -e "$HOME/$(basename $dotfile)" ]; then
		mv $HOME/$(basename $dotfile) $HOME/$EVACUATION
	fi
	ln -snf $dotfile $HOME 
done

#confirm and remove the evacuated file
if [ "$1" == "-y" ]; then
	rm -r $HOME/$EVACUATION
	echo "done."
	exit 0
fi

while :
do
	echo "Do you remove the evacuated file?"
	read -p "[y/n]:" ans
	if [ "$ans" == "y" ]; then
		rm -r $HOME/$EVACUATION
		echo "removed."
		break
	elif [ "$ans" == "n" ]; then break
	else continue
	fi
done

echo "done."
