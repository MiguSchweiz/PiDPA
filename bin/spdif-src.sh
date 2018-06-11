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

# check for ALSA restore
cat www/status|grep s_ >/dev/null
if [ $? -eq 1 ];then
	# kill running players defined in conf/alsa_clients.conf
	while read p; do
		pkill $p
	done <conf/alsa_clients.conf

	# set SPDIF input to EQ
        amixer -q -Dhw:RPiCirrus cset name='EQ1 Input 1' AIF2RX1
        amixer -q -Dhw:RPiCirrus cset name='EQ2 Input 1' AIF2RX2
fi

# set source state
echo "s_$1" >www/status
./bin/setvlevels.sh
cat /dev/null >www/title

# Switch SPDIF input
in='$I'$1"\r\n"
echo -e "$in" >> $SPDIF_TTY
