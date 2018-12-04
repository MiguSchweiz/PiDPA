#!/bin/bash
set -x
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
ps -ef|grep dmixer|grep -v grep|grep -v default|awk -F' ' '{print $2}'|xargs kill -9
pkill kodiTitle.sh

# check for ALSA restore
cat www/status|grep a_ >/dev/null
if [ $? -eq 1 ];then
        # remove spdif capture
        #amixer -q -Dhw:RPiCirrus cset name='AIF1TX1 Input 1' None
        #amixer -q -Dhw:RPiCirrus cset name='AIF1TX2 Input 1' None
	#set alsa to eq
	amixer -q -Dhw:RPiCirrus cset name='EQ1 Input 1' AIF1RX1
	amixer -q -Dhw:RPiCirrus cset name='EQ2 Input 1' AIF1RX2
fi

# set source state
echo "a_$in" >www/status

#pause kodi
./bin/kodiRequest.sh pause

./bin/setvlevels.sh
cat /dev/null >www/title.htm


# start client if any
echo $in | egrep "[1-9]" &&
cat conf/media.conf |grep -v "#" > conf/.media &&
s=`sed "${in}q;d" conf/.media 2>/dev/null` &&

# pause / play kodi 
echo $s|grep kodi >/dev/null &&
[ $? -eq 0 ] && ./bin/kodiRequest.sh play

# execute media
$s 2>&1 &

# check if routes are set
#sleep 3
#./bin/fx.sh init
#./bin/routeSpdif.sh
