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

cat www/status|grep s_ >/dev/null
last=$?
echo "s_$1" >www/status

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
sleep 0.5
if [ $1 -eq 4 ]; then
    nr=0
else
    input=$1
    nr=$(( input + 6 ))
fi 
irsend SEND_ONCE Lindy KEY_$nr

# stop players
pkill castTitle.sh
pkill roonTitle.sh
#cat www/status|grep s_ >/dev/null
if [ $last -eq 1 ];then
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
#echo "s_$1" >www/status
echo "s_$1"

#pause kodi
./bin/kodiRequest.sh pause
# pause roon
./bin/roonRequest.sh stop

./bin/setvlevels.sh
unmute
cat /dev/null >www/title.htm
