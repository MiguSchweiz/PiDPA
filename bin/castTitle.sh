#!/bin/bash
exec 2>&1 >/dev/null
cd "$(dirname "$0")"
cd ..

while [ true ]; do
	./bin/castRequest.sh title >/tmp/title
        cat /tmp/title >www/title.htm
	sleep 5
done
