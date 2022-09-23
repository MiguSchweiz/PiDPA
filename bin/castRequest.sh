#!/bin/bash

#set -x
ip="192.168.1.138"

par=$1
chromecast -H $ip sessions|grep isIdle|grep true >/dev/null
state=$?
if [ "$par" == "playPause" ]; then
        if [ $state -eq 1 ];then
            chromecast -H $ip sessionDetails|grep playerState|grep PAUSED >/dev/null            
            if [ $? -eq 0 ];then
                chromecast -H $ip unpause
            else
                chromecast -H $ip pause
            fi
        fi
        exit 0
elif [ "$par" == "stop" ]; then
        [ $state -eq 1 ] && chromecast -H $ip pause 
	exit 0
elif [ "$par" == "play" ]; then
        [ $state -eq 1 ] && chromecast -H $ip unpause
        exit 0
elif [ "$par" == "title" ]; then
        [ $state -eq 0 ] && echo "-" && exit 0
        chromecast -H $ip sessions|jq '.[] .statusText'|sed -e s/Streamen\:.//|sed -e s/\"//g
        exit 0
fi

echo
echo "Usage: castRequest.sh <stop|play|title>"
echo


