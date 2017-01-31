#!/bin/bash

volume_interval="2%"

volume_up_cmd="amixer -D pulse set Master $volume_interval+"
volume_down_cmd="amixer -D pulse set Master $volume_interval-"
volume_mute_toggle_cmd="amixer -D pulse set Master toggle"

cmd=""

case $1 in
	up)
		cmd=$volume_up_cmd
		;;
	down)
		cmd=$volume_down_cmd
		;;
	toggle)
		cmd=$volume_mute_toggle_cmd
		;;
	*)
		echo $"Usage: $0 {up|down|toggle}"
		exit 1
esac

eval $cmd
