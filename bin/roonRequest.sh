#!/bin/bash

#set -x
# curl -s http://localhost:3001/roonAPI/listZones |jq
# PiDpa
zoneid=160124012dec84d7e2d2d2f9cde0b924ce36
#zoneid=1601528c8e6cd4a3c6598999a0e9df15ad32
# roonbridge
zoneid=1601526965c282c32a4066f30db7d3b583bf

par=$1
if [ "$par" == "playPause" ]; then
	curl -s http://localhost:3001/roonAPI/play_pause?zoneId=$zoneid
	exit 0
elif [ "$par" == "stop" ]; then
        curl -s http://localhost:3001/roonAPI/pause?zoneId=$zoneid
	exit 0
elif [ "$par" == "play" ]; then
        curl -s http://localhost:3001/roonAPI/play?zoneId=$zoneid
        exit 0
elif [ "$par" == "title" ]; then
        curl -s http://localhost:3001/roonAPI/getZone?zoneId=$zoneid|jq '.zone.state'| grep stopped >/dev/null
        if [ $? -ne 0 ]; then
            tit=`curl -s http://localhost:3001/roonAPI/getZone?zoneId=$zoneid|jq '.zone.now_playing.two_line.line1'| sed -e 's/"//g'`
            art=`curl -s http://localhost:3001/roonAPI/getZone?zoneId=$zoneid|jq '.zone.now_playing.two_line.line2'| sed -e 's/"//g'`
            if [ "$art" == "" ];then
                art=`curl -s http://localhost:3001/roonAPI/getZone?zoneId=$zoneid|jq '.zone.now_playing.three_line.line3'| sed -e 's/"//g'`
            fi
            echo $art" - "$tit
        else
            echo -
        fi
        exit 0
else
        curl -s http://localhost:3001/roonAPI/play_pause?zoneId=$zoneid
        exit 0
fi

echo
echo "Usage: roonRequest.sh <playPause|stop|play|title>"
echo


