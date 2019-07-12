#!/bin/bash
exec 2>&1 >/dev/null
cd "$(dirname "$0")"
cd ..

while [ true ]; do
	json=`curl -s --data-binary '{"jsonrpc": "2.0", "method": "Player.GetItem", "params": { "properties": ["title", "artist" ], "playerid": 0 }, "id": "AudioGetItem"}' -H 'content-type: application/json;' http://192.168.1.24:8080/jsonrpc`
	tit=`echo $json|python -c "import sys, json; reload(sys); sys.setdefaultencoding('utf8');print json.load(sys.stdin)['result']['item']['title']"|iconv -f utf8 -t iso_8859-15`
	artist=`echo $json|python -c "import sys, json; reload(sys); sys.setdefaultencoding('utf8');print json.load(sys.stdin)['result']['item']['artist'][0]"|iconv -f utf8 -t iso_8859-15`
	echo $artist" - "$tit >www/title.htm
	sleep 5
done
