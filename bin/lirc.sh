#!/bin/bash
#lircd -n --listen -H irtoy -d /dev/ttyACM0 /etc/lirc/lircd.conf
lircd -n --listen -H default -d /dev/lirc0 /etc/lirc/lircd.conf
