#!/bin/bash
#intel_pid=$(pidof intel-virtual-output)
#if [ ! -z $intel_pid ]; then
#kill -9 $intel_pid
#fi
#intel-virtual-output -f &
#sleep 10
connected_monitors=($(xrandr | grep " connected " | awk '{print$1}' ))
#is_connected=$(xrandr -q | grep VIRTUAL3 | head -n 1 | cut -d ' ' -f 2)
display_option=$(xrandr -q | grep "DP-1-1" | head -n 2| awk '{$1=$1};1'| cut -d ' ' -f3 | sed -r 's/([0-9]+x[0-9]+).*/\1/')
len=${#connected_monitors[@]}
if [ $len -gt 1 ]; then
#sh ~/.screenlayout/layout.sh
    xrandr --output ${connected_monitors[2]} --mode $display_option --right-of eDP1
    xrandr --output 
nitrogen --set-scaled ~/Downloads/images/anime_wallpaper_by_icetremens_dbmb9ay.jpg --save
elif [ $len -eq 1 ]; then
xrandr --auto
fi
