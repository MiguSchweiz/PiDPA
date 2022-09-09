#!/bin/bash
exec 2>&1 >/dev/null
cd "$(dirname "$0")"
# roonbridge
#cvlc alsa://plughw:1,0 -A alsa --alsa-audio-device dmixer &

# Squeezelite
#sudo systemctl restart SqueezeLite
sleep 1
./roonTitle.sh &
