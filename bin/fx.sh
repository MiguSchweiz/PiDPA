#!/bin/bash
exec >/dev/null
# set homedir
cd "$(dirname "$0")"

[ -e .fx ]||touch .fx

fx=`cat .fx`

if [ "$1" != "$fx" ]; then
	ps -ef|grep plughw|grep -v grep|awk -F' ' '{print $2}'|xargs kill
else
	exit
fi

if [ "$1" != "" ];then
	cvlc alsa://plughw:1,1 -A alsa --alsa-audio-device $1 2>&1 &
	echo "$1">.fx
fi
