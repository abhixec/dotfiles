#!/bin/bash
intel_pid=$(pidof intel-virtual-output)
if [ ! -z $intel_pid ]; then
kill -9 $intel_pid
fi
intel-virtual-output -f &
sleep 10
is_connected=$(xrandr -q | grep VIRTUAL3 | head -n 1 | cut -d ' ' -f 2)
display_option=$(xrandr -q | grep VIRTUAL3 | head -n 2 | sed -n 2p| awk '{$1=$1};1'| cut -d ' ' -f1)
if [ $is_connected == "connected" ]; then
#sh ~/.screenlayout/layout.sh
xrandr --output VIRTUAL3 --mode $display_option --right-of eDP1
nitrogen --set-scaled ~/Downloads/images/anime_wallpaper_by_icetremens_dbmb9ay.jpg --save
elif [ $is_connected == "disconnected" ]; then
xrandr --auto
fi
