#!/bin/bash

MESSAGE=$(~/whatismyip.py) 
/usr/local/bin/ntfy send  $MESSAGE
