#!/bin/bash
# set homedir
cd "$(dirname "$0")"

co2=`curl -s 'https://api.thingspeak.com/channels/325562/fields/4.json?api_key=#APIKEY#&results=1' |python -c "import sys, json; print json.load(sys.stdin)['feeds'][0]['field4']"`
aq=`curl -s 'https://api.thingspeak.com/channels/325562/fields/3.json?api_key=#APIKEY#&results=1' |python -c "import sys, json; print json.load(sys.stdin)['feeds'][0]['field3']"`
aq=`echo $aq |sed -e 's/\.00//'`
if [ $co2 -ge 300 -o $aq -ge 300 ]; then
	sudo pkill mplayer
	sudo pkill aplay
	sudo pkill vlc
	pkill mplayer
	pkill aplay
	./alsa-src.sh
	cvlc --loop ../media/buzzer.wav
fi

