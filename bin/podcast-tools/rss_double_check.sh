#!/bin/bash
check=""
exec 2>/dev/null
while read rss;do
	echo $check|grep $rss>/dev/null
	if [ $? -eq 1 ];then 
		echo $rss	
		check=$check";"$rss
	fi
done<$1
