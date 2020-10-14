#!/bin/bash
#set -x
# set homedir
cd "$(dirname "$0")"
cd ..

# Help
if [ "$1" == "-h" ];then
	echo
	echo "Options:"
	echo "   <media number>		entry number in conf/media.conf"
	echo "   -h			Help"
	echo
	exit 0
fi

[ -z $1 ] && in=0 || in=$1

# kill running players
ps -ef|grep vlc|grep dmixer|grep -v grep|grep -v default|awk -F' ' '{print $2}'|xargs kill -1 2>/dev/null
#pkill vlc
while [ true ];do
        ps -ef|grep -v grep|grep dmixer 2>/dev/null
        [ $? -eq 1 ] && break
done
pkill kodiTitle.sh 2>/dev/null
pkill roonTitle.sh 2>/dev/null

# unmute pi
dsptoolkit apply-settings bin/settings/enablePi

# set source state
echo "a_$in" >www/status

#pause kodi and roon
./bin/kodiRequest.sh pause
./bin/roonRequest.sh pause

./bin/setvlevels.sh
cat /dev/null >www/title.htm


# start client if any
echo $in | egrep "[1-9]" &&
cat conf/media.conf |grep -v "#" > conf/.media &&
s=`sed "${in}q;d" conf/.media 2>/dev/null` &&

# pause / play kodi 
echo $s|grep kodi >/dev/null &&
if [ $? -eq 0 ]; then
    ./bin/kodiRequest.sh play
    irsend SEND_ONCE HDMISwitch KEY_1
fi

# execute media
$s 2>&1 &

# pause play roon
echo $s|grep roon >/dev/null
if [ $? -eq 0 ]; then
    #sleep 0.5
    ./bin/roonRequest.sh play
    #irsend SEND_ONCE HDMISwitch KEY_2
fi

# check if routes are set
#sleep 3
#./bin/fx.sh init
#./bin/routeSpdif.sh
