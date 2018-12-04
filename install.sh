#!/bin/bash
cd "$(dirname "$0")"
hd=`pwd`

sudo apt-get install apache2 php7.0 bs2b-ladspa vlc kodi eyed3 libid3-tools ladspa-sdk libtool libfftw3-dev fftw3
sudo apt-get install samba-common-bin samba libasound2-plugin-equal
#sudo pip install mutagen

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
sudo chown -R www-data:www-data www
sudo chmod 777 www/* 
sudo chmod 755 www/img
sudo chmod 777 www/img/*
sudo usermod -a -G pi www-data


echo "### install apache config"
printf "do you want to install new apache config? (y/n): "
read a
if [ "$a" == "y" ];then
	sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
	cat system/apache.conf | sed -e "s#PIDPA_DIR#$hd#" >/tmp/temp.txt
	sudo mv /tmp/temp.txt /etc/apache2/sites-available/000-default.conf	
	sudo service apache2 restart 2>/dev/null
fi

echo "### install alsa config"
ln -s PiDPA/system/asoundrc $HOME/.asoundrc
#cp system/asoundrc $HOME/.asoundrc

echo  "### init alsa"
./bin/init-alsa.sh

echo "### mount sdcard"
df -k|grep usb0
if [ $? -eq 1 ];then
	sudo mkdir -p /mnt/usb0
	sudo echo "UUID=DA22-C828 /mnt/usb0 vfat defaults,auto,umask=000,users,rw 0 0" >>/etc/fstab
	sudo mount /mnt/usb0
fi

echo "### create raveloxmidi startup script"
sudo cp system/raveloxmidi.service /etc/systemd/system/raveloxmidi.service
sudo systemctl start raveloxmidi.service

echo
echo "### start kodi and do:"
echo "cp system/kodi.userdata.advancedsettings.xml ~/.kodi/userdata/advancedsettings.xml"

echo "### Add line to /etc/sudoers: "
echo "%pi ALL=(ALL) NOPASSWD: ALL"
echo
echo "### reboot !!!"
