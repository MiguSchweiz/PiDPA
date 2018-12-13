#!/bin/bash

# set homedir
cd "$(dirname "$0")"
cd ../cirrus

# set cirrus config
./Reset_paths.sh -q
./Playback_to_SPDIF.sh -q
#./Playback_to_Lineout.sh -q
./Record_from_SPDIF.sh -q
./Playback_to_Headset.sh -q

# enable EQ
amixer -q -Dhw:RPiCirrus cset name='AIF2TX1 Input 1' EQ1
amixer -q -Dhw:RPiCirrus cset name='AIF2TX2 Input 1' EQ2
amixer -q  -Dhw:RPiCirrus cset name='HPOUT1L Input 1' EQ1
amixer -q  -Dhw:RPiCirrus cset name='HPOUT1R Input 1' EQ2

# set ALSA to EQ input
amixer -q -Dhw:RPiCirrus cset name='EQ1 Input 1' AIF1RX1
amixer -q -Dhw:RPiCirrus cset name='EQ2 Input 1' AIF1RX2

# ALSA store 
sudo alsactl store

#switch off spdif switch leds
echo -e '$CLI0\r\n' >/dev/ttyACM0
