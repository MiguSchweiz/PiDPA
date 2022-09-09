#!/bin/bash
set -x
exec 2>&1 >/tmp/sl.log
echo " start sl"
#squeezelite -n pidpa -r 96000 -o dmix:CARD=sndrpihifiberry,DEV=0
#squeezelite -n pidpa -o dmix:CARD=sndrpihifiberry,DEV=0
squeezelite -n pidpa -r 96000 -o dmixer
