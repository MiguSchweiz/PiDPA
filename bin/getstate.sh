#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

while [ true ]; do
	exec 2>/dev/null
	ls .eq && eq=0 || eq=1
	ls .hmute && hm=0 || hm=1
	ls .smute && sm=0 || sm=1
	p=`cat www/status`
	title=`cat www/title |egrep -a "Title" |tail -1|awk -F"=" '{ print $2 }'`
	echo $p";"$eq";"$sm";"$hm";"$title > www/status.htm
	sleep 0.5
done
