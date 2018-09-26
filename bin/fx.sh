#!/bin/bash
set -x
# set homedir
cd "$(dirname "$0")"
cd ..

[ -e .fx ]||echo default > .fx

fx=`cat .fx`

if [ "$fx" != "norm_cf" ];then
	if ([ "$1" != "$fx" ] && [ "$2" == "off" ]) || ([ "$1" == "$fx" ] && [ "$2" == "on" ]);then
		exit
	fi
fi

echo $fx |grep "$1" >/dev/null
if [ $? -eq 0 ] && [ "$2" == "on" ];then
	exit
fi

ps -ef|grep plughw|grep -v grep|awk -F' ' '{print $2}'|xargs kill 2>/dev/null

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
echo $target

exec >/dev/null

cvlc alsa://plughw:1,1 -A alsa --alsa-audio-device $target 2>&1 &

