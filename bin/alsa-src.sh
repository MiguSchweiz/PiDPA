#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

# Help
if [ "$1" == "-h" ];then
	echo
	echo "Options:"
	echo "   <media number>		entry number in conf/media.conf"
	echo "   -h			Help"
	echo
	exit 0
fi

# kill running players defined in conf/alsa_clients.conf
while read p; do
  pkill $p
done <conf/alsa_clients.conf

# check for ALSA restore
cat www/status|grep a_ >/dev/null
if [ $? -eq 1 ];then
	echo "Restore ALSA settings"
	sudo alsactl restore
fi

# set source state
echo "a_$1" >www/status

# start client if any
[[ $1 == ?(-)+([0-9]) ]] &&
cat conf/media.conf |grep -v "#" > conf/.media &&
s=`sed "${1}q;d" conf/.media` &&
$s 2>&1 &

