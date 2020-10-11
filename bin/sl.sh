#!/bin/bash
set -x
exec 2>&1 >/tmp/sl.log
echo " start sl"
squeezelite -n pidpa -o dmix:CARD=sndrpihifiberry,DEV=0

