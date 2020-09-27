#!/bin/bash
exec 2>&1 >/dev/null
cd "$(dirname "$0")"
cd ..

while [ true ]; do
	./bin/roonRequest.sh title >www/title.htm
	sleep 5
done
