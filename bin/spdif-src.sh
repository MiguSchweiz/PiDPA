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
if [ ! -f .hmute ];then
	./bin/setvol.sh h m
	hm=1
fi
if [ ! -f .smute ];then
        ./bin/setvol.sh s m
        sm=1
fi

function unmute(){
	# restore muted channels
	[ ! -z $hm ] && ./bin/setvol.sh h m
	[ ! -z $sm ] && ./bin/setvol.sh s m
}

# Switch SPDIF input
cs=`cat  www/status`
if [ $1 -eq 1 ];then
	s=5
elif [ $1 -eq 4 ];then
	s=7
else
	s=$1
fi
in='$I'$s"\r\n"
echo -e "$in" >> $SPDIF_TTY
lost=0
while read p; do
	#echo $p
	echo $p | egrep "lost|0x60">/dev/null && lost=1
	if [ $lost -eq 1 ];then
		echo $cs|grep a_>/dev/null
		if [ $? -eq 0 ]; then
			echo failed
			unmute
			exit 1
		fi
		si=`echo $p | grep "Switch" | awk -F'(' '{print $2}'| sed -e "s/)//"`
		if [ "$si" != "" ];then
			echo $si
			if [ "$si" -eq $s ];then
				echo ok	
				break
			else
				echo "s_"$si
				unmute
				exit 1	
			fi
		fi
	else
		echo $p | egrep '0x20|0x24'>/dev/null
		if [ $? -eq 0 ]; then
			break
		fi
	fi
done </dev/ttyACM0

# check for ALSA restore
pkill roonTitle.sh
cat www/status|grep s_ >/dev/null
if [ $? -eq 1 ];then
	# kill running players
	ps -ef|grep dmixer|grep -v grep| grep -v default|awk -F' ' '{print $2}'|xargs kill 2>/dev/null
	pkill kodiTitle.sh
        pkill roonTitle.sh

	# set SPDIF input to EQ
        amixer -q -Dhw:RPiCirrus cset name='EQ1 Input 1' AIF2RX1
        amixer -q -Dhw:RPiCirrus cset name='EQ2 Input 1' AIF2RX2
	# fx mode
	#amixer -q -Dhw:RPiCirrus cset name='AIF1TX1 Input 1' AIF2RX1
        #amixer -q -Dhw:RPiCirrus cset name='AIF1TX2 Input 1' AIF2RX2
fi

# set source state
echo "s_$1" >www/status
echo "s_$1"

#pause kodi
./bin/kodiRequest.sh pause
# pause roon
curl -s http://localhost:3001/roonAPI/pause?zoneId=16013ea295456ef9d39b850af763a0cccc27

./bin/setvlevels.sh
unmute
cat /dev/null >www/title.htm
