#!/bin/bash
#set -x

# set homedir
cd "$(dirname "$0")"
cd ..

# Help
if [ "$1" == "-h" ];then
        echo
        echo "Options:"
        echo "   <spdif input>		SPDIF Input" 
        echo "   -h                     Help"
        echo
        exit 0
fi

# mute channels
if [ ! -f .mute ];then
	./bin/setvol.sh m
	m=1
fi

function unmute(){
	# restore muted channels
	[ ! -z $m ] && ./bin/setvol.sh um
}

# Switch HDMI input
irsend SEND_ONCE Lindy KEY_$1

# stop players
pkill castTitle.sh
pkill roonTitle.sh
cat www/status|grep s_ >/dev/null
if [ $? -eq 1 ];then
	# kill running players
	ps -ef|grep dmixer|grep vlc|grep -v grep| grep -v default|awk -F' ' '{print $2}'|xargs kill 2>/dev/null
	pkill kodiTitle.sh
        pkill mplayer
        dsptoolkit apply-settings bin/settings/enableSpdif
fi

#start cast title
if [ $1 -eq 2 ];then
    ./bin/castRequest.sh play
    ./bin/castTitle.sh &
else
    ./bin/castRequest.sh stop
fi
# set source state
echo "s_$1" >www/status
echo "s_$1"

#pause kodi
./bin/kodiRequest.sh pause
# pause roon
./bin/roonRequest.sh stop

./bin/setvlevels.sh
unmute
cat /dev/null >www/title.htm
