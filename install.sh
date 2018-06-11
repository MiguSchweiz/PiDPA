#!/bin/bash
cd "$(dirname "$0")"
hd=`pwd`

echo "### check for latest cirrus driver in /boot/config.txt: "
egrep "rpi-cirrus-wm5102$" /boot/config.txt 
if [ $? -eq 1 ];then
	echo "### install latest raspbian release, follow instructions under doc/RPi Linux driver for Cirrus Audio Card.html "
	printf "### latest cirrus driver not present, do you want to continue ? (y/n):"
	read a
	[ "$a" != "y" ] && exit 1
else
	echo OK
fi

echo "### set file permissions"
sudo chown -R pi:pi .
chmod 755 bin/*
chmod 755 cirrus/*

echo "### Install pidpa-state service"
cat system/pidpa-state | sed -e "s#PIDPA_DIR#$hd#" >/tmp/temp.txt
sudo mv /tmp/temp.txt /etc/init.d/pidpa-state
sudo chmod 755 /etc/init.d/pidpa-state
sudo update-rc.d pidpa-state defaults 2>/dev/null
sudo service pidpa-state start

echo "### install apache config"
printf "do you want to install new apache config? (y/n): "
read a
if [ "$a" == "y" ];then
	sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/default.sav
	cat system/apache.conf | sed -e "s#PIDPA_DIR#$hd#" >/tmp/temp.txt
	sudo mv /tmp/temp.txt /etc/apache2/sites-available/default	
	sudo service apache2 restart 2>/dev/null
fi

