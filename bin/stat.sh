#!/bin/bash
ps -ef | grep -v grep|grep getstate.sh
if [ $? -eq 0 ]; then
        exit
fi

echo p|sudo su - pi -c /home/pi/PiDPA/bin/getstate.sh
