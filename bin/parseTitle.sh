#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

while read line; do
	echo $line | grep "Title" >/dev/null
	if [ $? -eq 0 ];then
		echo $line | grep "Title" |awk -F"=" '{ print $2 }' >www/title.htm
	fi
done < "${1:-/dev/stdin}"
