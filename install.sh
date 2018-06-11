#!/bin/bash
cd "$(dirname "$0")"
hd=`pwd`
cat system/state.conf | sed -e "s#PIDPA_DIR#$hd#" >/tmp/temp.txt
mv /tmp/temp.txt /etc/init/pidpa_state.conf
