#!/bin/bash

# Kill camera
pkill -f main.py
monitor_primario="HDMI-2"
monitor_secundario="HDMI-1"
# Adjust resolution and touchscreen - FHD
xrandr --output "$monitor_primario" --mode 1920x1080 --primary
xrandr --output "$monitor_secundario" --mode 1024x768 --right-of "$monitor_primario" --pos 1920x156
xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.652 0 0  0 1 0  0 0 1
# Adjust resolution and touchscreen - 1024x768
# xrandr --output "$monitor_primario" --mode 1024x768 --primary
# xrandr --output "$monitor_secundario" --mode 1024x768 --right-of "$monitor_primario" --pos 1024x0
# xinput set-prop "ILITEK ILITEK-TP" "Coordinate Transformation Matrix" 0.5 0 0  0 1 0  0 0 1
# Open camera
sleep 10
python3 /root/pythonCamIP/main.py

