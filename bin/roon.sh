#!/bin/bash
exec 2>&1 >/dev/null
cd "$(dirname "$0")"
cvlc alsa://plughw:1,0 -A alsa --alsa-audio-device dmixer &
#ps -ef |grep -v grep|grep roonTitle.sh >/dev/null || ./roonTitle.sh &
./roonTitle.sh &
