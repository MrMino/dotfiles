#!/bin/bash

page=$(cal)

page=$(echo $page | sed "s/\0x08/x/g" | sed "s/\0x5f/!/g")

notify-send "$page"
#| sed 's/ !/ <b>/g'

