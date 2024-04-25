#!/bin/bash

WDIR="$HOME/exper"
EVACUATION=".___EVACU___"

#specify ignore-files
#temp: -o -name "*.*" \
dotfiles=( $(find $WDIR/.dotfiles -maxdepth 1 ! \( \
	-name "bin" \
	-o -name ".git" \
	-o -name ".gitignore" \
\)))

#confirm existence: $WDIR
if [ ! -d "$WDIR/.dotfiles" ]; then
	echo "Error: $WDIR/.dotfiles doesn't exist." >&2
	exit 1
fi

unset 'dotfiles[0]'
echo "Apply dotfiles."

#confirm existence: $EVACUATION
if [ -d "$WDIR/$EVACUATION" ]; then
	echo "Confirm: $WDIR/$EVACUATION have already existed."
	echo "Do you want to use this as is? (or clean)"
	while :
	do
		read -p "[y/n]:" ans
		if [ "$ans" == "y" ]; then break
		elif [ "$ans" == "n" ]; then 
			rm -r $WDIR/$EVACUATION
			echo "Cleaned."
			mkdir $WDIR/$EVACUATION
			break
		else continue
		fi
	done
else
	mkdir $WDIR/$EVACUATION
fi

#move duplicate files and create links
for dotfile in ${dotfiles[@]};do
	if [ -e "$WDIR/$(basename $dotfile)" ]; then
		mv $WDIR/$(basename $dotfile) $WDIR/$EVACUATION
	fi
	ln -snf $dotfile $WDIR 
done

#confirm and throw away the evacuated file
if [ "$1" == "-y" ]; then
	rm -r $WDIR/$EVACUATION
	echo "done."
	exit 0
fi

while :
do
	echo "Do you throw away the evacuated file?"
	read -p "[y/n]:" ans
	if [ "$ans" == "y" ]; then
		rm -r $WDIR/$EVACUATION
		echo "Threw away."
		break
	elif [ "$ans" == "n" ]; then break
	else continue
	fi
done

echo "done."
