#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..
pkill vlc


echo "# init headphone state"
ls .hp 2>&1 >/dev/null
if [ $? -eq 0 ];then
	echo -n -e '\xA0\x01\x01\xA2'>/dev/ttyUSB0
fi

echo "# init fx route"
