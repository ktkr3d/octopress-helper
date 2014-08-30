#!/bin/bash

OCTOPRESS_DIR=/mnt/common/repos/ktkr3d.github.io

# SOURCE_REPOSITORY=origin
SOURCE_REPOSITORY=bitbucket

PATH=$PATH:$HOME/bin:$HOME/.rvm/bin # Add RVM to PATH for scripting
source $HOME/.rvm/scripts/rvm
cd $OCTOPRESS_DIR

if [ -e /usr/bin/yad ]; then
ZENITY_ALT=yad
else
ZENITY_ALT=zenity
fi

while :
do
	pick=$($ZENITY_ALT --height=320 --width=240 --print-column=2 --list --title "Octopress Helper" --text "Select Action." --radiolist --column Pick --column dummy --column Action --hide-column 2 true 0 "New Post" false 1 "New Page" false 2 "Generate" false 3 "Deploy" false 4 "Preview" false 5 "Open Posts Folder" false 6 "Push Source");
	case $pick in
		"0|")
			post_title=$(zenity --entry --title="New Post" --text="Enter Title." )
			if [ ${#post_title} > 0 ] ; then
				rake new_post["$post_title"] >($ZENITY_ALT --progress --title="New Post" --pulsate --auto-close --auto-kill)
			fi
			;;
		"1|") 
			page_title=$(zenity --entry --title="New Page" --text="Enter Title." )
			if [ ${#page_title} > 0 ] ; then
				rake new_page["$page_title"] >($ZENITY_ALT --progress --title="New Page" --pulsate --auto-close --auto-kill)
			fi
			;;
		"2|")
			rake generate >(zenity --progress --title="Generate" --pulsate --auto-close --auto-kill)
			;;
		"3|")
			rake deploy >(zenity --progress --title="Deploy" --pulsate --auto-close --auto-kill)
			;;
		"4|")
			rake preview >(zenity --progress --title="Preview" --pulsate --auto-close --auto-kill)
			;;
		"5|")
			nautilus $OCTOPRESS_DIR/source/_posts/ &
			;;
		"6|")
			git add . && git commit -m 'update' && git push -u $SOURCE_REPOSITORY source >(zenity --progress --title="Push Source" --pulsate --auto-close --auto-kill)
			;;
		*)
			break
			;;
	esac
done
