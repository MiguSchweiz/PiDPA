#!/bin/bash
cd "$(dirname "$0")"
cd ..

while [ true ]; do
	curl -s --data-binary '{"jsonrpc":"2.0","method":"Player.GetItem","params":{"playerid":0},"id":"1"}' -H 'content-type: application/json;' http://192.168.1.24:8080/jsonrpc|python -c "import sys, json; print json.load(sys.stdin)['result']['item']['label']">www/title.htm
	sleep 5
done
