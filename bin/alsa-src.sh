#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

# Help
if [ "$1" == "-h" ];then
	echo
	echo "Options:"
	echo "   <player number>	entry number in etc/players.conf"
	echo "   -h			Help"
	echo
	exit 0
fi

# kill running players
while read p; do
  pkill $p
done <etc/alsa_clients.conf

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
cat etc/media.conf |grep -v "#" > etc/.media &&
s=`sed "${1}q;d" etc/.media` &&
$s 2>&1 &

