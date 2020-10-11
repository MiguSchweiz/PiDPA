#!/bin/bash

# specify SPDIF switch tty
SPDIF_TTY=/dev/ttyACM0

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
fi

function unmute(){
	# restore muted channels
	[ ! -z $m ] && ./bin/setvol.sh um
}

# Switch SPDIF input

# check for ALSA restore
pkill roonTitle.sh
cat www/status|grep s_ >/dev/null
if [ $? -eq 1 ];then
	# kill running players
	ps -ef|grep dmixer|grep vlc|grep -v grep| grep -v default|awk -F' ' '{print $2}'|xargs kill 2>/dev/null
	pkill kodiTitle.sh
        dsptoolkit apply-settings bin/settings/enableSpdif
fi

# set source state
echo "s_$1" >www/status
echo "s_$1"

#pause kodi
./bin/kodiRequest.sh pause
# pause roon
./bin/roonRequest.sh pause

./bin/setvlevels.sh
unmute
cat /dev/null >www/title.htm
