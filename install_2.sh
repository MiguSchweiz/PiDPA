#!/bin/bash
cd "$(dirname "$0")"
hd=`pwd`

sudo apt-get install apache2 php7.0 vlc kodi libasound2-plugin-equal

echo "### check for hifiberry  driver in /boot/config.txt: "
egrep "hifiberry-dacplusdsp$" /boot/config.txt 
if [ $? -eq 1 ];then
	cp /boot/config.txt /tmp/config.txt	
	echo "dtoverlay=hifiberry-dacplusdsp" >>/tmp/config.txt
	cp /tmp/config.txt /boot/config.txt
fi

echo "### set file permissions"
sudo chown -R pi:pi .
chmod 755 bin/*
sudo chown -R www-data:www-data www
sudo chmod 777 www/* 
sudo chmod 755 www/img
sudo chmod 777 www/img/*
sudo usermod -a -G pi www-data


echo "### install apache config"
printf "do you want to install new apache config? (y/n): "
read a
if [ "$a" == "y" ];then
	cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.sav
	cp /tmp/temp.txt /etc/apache2/sites-available/000-default.conf	
	service apache2 restart 2>/dev/null
fi

echo "### install alsa config"
ln -s PiDPA/system/asoundrc $HOME/.asoundrc
#cp system/asoundrc $HOME/.asoundrc


sudo systemctl start pidpastartup.service

echo
echo "### install ladspa dsp config:"
mkdir -p /home/pi/.config/ladspa_dsp
cp system/dsp/* /home/pi/.config/ladspa_dsp/


echo
echo "### start kodi and do:"

echo "### Add line to /etc/sudoers: "
echo "%pi ALL=(ALL) NOPASSWD: ALL"
echo
echo "### reboot !!!"
