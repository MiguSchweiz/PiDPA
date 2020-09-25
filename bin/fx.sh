#!/bin/bash
#set -x
# set homedir
cd "$(dirname "$0")"
cd ..

[ -e .fx ]||echo default > .fx

fx=`cat .fx`

if [ "$1" == "init" ]; then
	ps -ef|grep -v grep|grep 'alsa://plughw:1,1'>/dev/null
	[ $? -eq 0 ] && exit
	exec >/dev/null
	#cvlc alsa://default --file-caching=0 --sout-mux-caching=0 -A alsa --alsa-audio-device dmixer 2>&1 &	
	#sleep 1
	cvlc alsa://plughw:1,1 --file-caching=0 --sout-mux-caching=0 -A alsa --alsa-audio-device $fx 2>&1 &
	exit
elif [ "$1" == "checkdrc" ]; then
	target=$fx
	if [ ! -f ./.smute ]; then
 	        [ "$target" = "norm" ] && target="norm_drc"
        	[ "$target" = "default" ] && target="drc"
	fi
	ps -ef|grep plughw|grep -v grep|awk -F' ' '{print $2}'|xargs kill -1 2>/dev/null
	cvlc alsa://plughw:1,1 --file-caching=0 --sout-mux-caching=0 -A alsa --alsa-audio-device $target 2>&1 &
        exit 0
fi
	

if [ "$fx" != "norm_cf" ];then
	if ([ "$1" != "$fx" ] && [ "$2" == "off" ]) || ([ "$1" == "$fx" ] && [ "$2" == "on" ]);then
		exit
	fi
fi

echo $fx |grep "$1" >/dev/null
if [ $? -eq 0 ] && [ "$2" == "on" ];then
	exit
fi

ps -ef|grep "plughw:1,1"|grep -v grep|awk -F' ' '{print $2}'|xargs kill -1 2>/dev/null
while [ true ];do
	ps -ef|grep -v grep|grep pughw 2>/dev/null
	[ $? -eq 1 ] && break
done

if [ "$1" != "" ];then
	nfx=$1
else
	exit
fi
[ -z "$2" ] && exit

if [ "$2" == "on" ];then
	if [ "$fx" == "default" ] || [ "$fx" == "" ]; then
		target=$nfx
	elif [ "$fx" == "norm" ] || [ "$fx" == "cf" ]; then
		target="norm_cf"
	fi
else
	if [ "$fx" == "norm" ] || [ "$fx" == "cf" ]; then
		target="default"
	elif [ "$nfx" == "norm" ]; then
		target="cf"
	elif [ "$nfx" == "cf" ]; then
		target="norm"
	fi
fi

echo $target > .fx

# check for headphones active and use no DRC
if [ ! -f ./.smute ]; then
	#[ "$target" = "norm" ] && target="norm_drc"
	#[ "$target" = "default" ] && target="drc"
	echo
fi

exec >/dev/null
echo $target

#cvlc alsa://plughw:1,1 --file-caching=0 --sout-mux-caching=0 -A alsa --alsa-audio-device $target 2>&1 &
cvlc alsa://plughw:1,1 -A alsa --alsa-audio-device $target 2>&1 &
