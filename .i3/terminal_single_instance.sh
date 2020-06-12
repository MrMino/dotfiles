#!/bin/sh
TERMINAL_NAME='gnome-terminal'
count=`pgrep $TERMINAL_NAME | wc -l`
echo "pgrep counted $count occurrence(s) of $TERMINAL_NAME"
if [ $count -eq 0 ]; then
	eval $TERMINAL_NAME
else
	i3-msg "[title=Terminal class=\"Gnome-terminal\"] focus"

fi
