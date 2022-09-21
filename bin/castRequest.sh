#!/bin/bash

#set -x
ip="192.168.1.103"

par=$1
chromecast -H $ip sessions|grep isIdle|grep true >/dev/null
state=$?
if [ "$par" == "stop" ]; then
        [ $state -eq 1 ] && chromecast -H $ip pause 
	exit 0
elif [ "$par" == "play" ]; then
        [ $state -eq 1 ] && chromecast -H $ip unpause
        exit 0
elif [ "$par" == "title" ]; then
        [ $state -eq 0 ] && echo "-" && exit 0
        chromecast -H $ip sessions|jq '.[] .statusText'|sed -e s/Streamen\:.//
        exit 0
fi

echo
echo "Usage: castRequest.sh <stop|play|title>"
echo


