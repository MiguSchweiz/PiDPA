#!/bin/bash

exec >/dev/null

par=$1
stat=`curl -s --data-binary '{"jsonrpc": "2.0",  "method": "Player.GetProperties", "params": {"properties": ["speed"], "playerid": 0}, "id": 1}' -H 'content-type: application/json;' http://192.168.1.24:8080/jsonrpc`
if [ "$par" == "play" ]; then
	echo $stat|egrep "speed\":0"
	[ $? -eq 0 ] &&
	curl -s --data-binary '{"jsonrpc": "2.0", "method": "Player.PlayPause", "params": { "playerid": 0 }, "id": 1}' -H 'content-type: application/json;' http://192.168.1.24:8080/jsonrpc
	exit 0
elif [ "$1" == "pause" ]; then
        echo $stat|egrep "speed\":1"
        [ $? -eq 0 ] &&
        curl -s --data-binary '{"jsonrpc": "2.0", "method": "Player.PlayPause", "params": { "playerid": 0 }, "id": 1}' -H 'content-type: application/json;' http://192.168.1.24:8080/jsonrpc
	exit 0
fi

echo
echo "Usage: kodiRequest.sh <play|pause>"
echo


