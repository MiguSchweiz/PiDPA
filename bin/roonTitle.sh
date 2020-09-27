#!/bin/bash
exec 2>&1 >/dev/null
cd "$(dirname "$0")"
cd ..

while [ true ]; do
        tit=`curl -s http://localhost:3001/roonAPI/getZone?zoneId=16013ea295456ef9d39b850af763a0cccc27|jq '.zone.now_playing.two_line.line1'| sed -e 's/"//g'` 
        art=`curl -s http://localhost:3001/roonAPI/getZone?zoneId=16013ea295456ef9d39b850af763a0cccc27|jq '.zone.now_playing.two_line.line2'| sed -e 's/"//g'`
	echo $art" - "$tit >www/title.htm
	sleep 5
done
