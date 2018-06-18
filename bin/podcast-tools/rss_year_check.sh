#!/bin/bash
exec 2>/dev/null
while read rss;do
	echo $rss|grep "#" >/dev/null
	if [ $? -eq 1 ]; then
		curl $rss|grep "pubDate"|grep "2018" >/dev/null
		if [ $? -eq 0 ]; then
			echo $rss
		fi
	fi
done<$1
