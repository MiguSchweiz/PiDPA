#!/bin/bash
cd "$(dirname "$0")"
cd ..

while [ true ]; do
	tit=`curl -s --data-binary '{"jsonrpc":"2.0","method":"Player.GetItem","params":{"playerid":0},"id":"1"}' -H 'content-type: application/json;' http://192.168.1.24:8080/jsonrpc|python -c "import sys, json; reload(sys); sys.setdefaultencoding('utf8');print json.load(sys.stdin)['result']['item']['label']"|iconv -f utf8 -t iso_8859-15`
	echo $tit>www/title.htm
	sleep 5
done
