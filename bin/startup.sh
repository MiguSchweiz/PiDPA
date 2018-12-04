#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..
pkill vlc


# raveloxmidi
echo |grep nothing
while [ $? -ne 0 ]; do
	sleep 1
	aplaymidi -l|grep Midi >/dev/null
done
/usr/local/bin/raveloxmidi 

echo "# init headphone state"
ls .smute 2>&1 >/dev/null
if [ $? -eq 0 ];then
	echo -n -e '\xA0\x01\x01\xA2'>/dev/ttyUSB0
fi

echo "# init fx route"
./bin/fx.sh init
