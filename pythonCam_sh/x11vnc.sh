#!/bin/bash

sleep 15
nohup x11vnc -nopw -noshm -noxdamage -forever -env FD_XDM=1 -cursor arrow -shared -rfbport 5900 -display :0 -auth /var/run/lightdm/root/:0 &>> /dev/null &
