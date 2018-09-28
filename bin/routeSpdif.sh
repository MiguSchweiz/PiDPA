#!/bin/bash
exec >/dev/null
ps -ef |grep -v grep|grep 'alsa://default'>/dev/null
[ $? -eq 0 ] && exit
cvlc alsa://default --file-caching=0 --sout-mux-caching=0 -A alsa --alsa-audio-device dmixer 2>&1 &
