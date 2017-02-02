#!/bin/bash

volume_interval="2%"

volume_up_cmd="amixer -D pulse set Master $volume_interval+"
volume_down_cmd="amixer -D pulse set Master $volume_interval-"
volume_max_cmd="amixer -D pulse set Master 100%"
volume_min_cmd="amixer -D pulse set Master 0%"
volume_mute_toggle_cmd="amixer -D pulse set Master toggle"
volume_mute_cmd="amixer -D pulse set Master mute"
volume_unmute_cmd="amixer -D pulse set Master unmute"


volume_up(){
	eval $volume_up_cmd
}

volume_down(){
	eval $volume_down_cmd
}

volume_toggle(){
	eval $volume_mute_toggle_cmd
}

volume_mute(){
	eval $volume_mute_cmd
}

volume_unmute(){
	eval $volume_unmute_cmd
}

volume_max(){
	eval $volume_max_cmd
}

volume_min(){
	eval $volume_min_cmd
}

case $1 in
	up)
		volume_up
		;;
	down)
		volume_down
		;;
	mute)
		volume_mute
		;;
	unmute)
		volume_unmute
		;;
	max)
		volume_max
		;;
	min)
		volume_min
		;;
	toggle)
		volume_toggle
		;;
	*)
		echo $"Usage: $0 {up|down|mute|unmute|min|max|toggle|display}"
		exit 1
esac
