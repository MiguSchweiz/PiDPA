#!/bin/bash

#set -x

zoneid=16013ea295456ef9d39b850af763a0cccc27

par=$1
if [ "$par" == "play" ]; then
	curl -s http://localhost:3001/roonAPI/play?zoneId=$zoneid
	exit 0
elif [ "$par" == "pause" ]; then
        curl -s http://localhost:3001/roonAPI/pause?zoneId=$zoneid
	exit 0
elif [ "$par" == "title" ]; then
        curl -s http://localhost:3001/roonAPI/getZone?zoneId=$zoneid|jq '.zone.state'| grep stopped
        if [ $? -ne 0 ]; then
            tit=`curl -s http://localhost:3001/roonAPI/getZone?zoneId=$zoneid|jq '.zone.now_playing.two_line.line1'| sed -e 's/"//g'`
            art=`curl -s http://localhost:3001/roonAPI/getZone?zoneId=$zoneid|jq '.zone.now_playing.two_line.line2'| sed -e 's/"//g'`
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
echo "Usage: roonRequest.sh <play|pause|title>"
echo


