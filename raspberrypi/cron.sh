#!/bin/bash
#set -ex
MESSAGE=$(~/whatismyip.py) 
if ! [ -f ~/.my.ip ]; then
  echo $MESSAGE > ~/.my.ip
else
  PREVIOUS_IP=$(cat ~/.my.ip) 
  if [ "$PREVIOUS_IP" = "$MESSAGE" ]; then
	:
  else
    /usr/local/bin/ntfy send  $MESSAGE
    echo $MESSAGE > ~/.my.ip 
  fi
fi
