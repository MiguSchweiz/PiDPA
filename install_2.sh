#!/bin/bash
whoami |grep root

if [ $? -eq 1 ]; then
    echo " you must be root!"
    exit 1
fi


cd "$(dirname "$0")"
hd=`pwd`

sudo apt-get install apache2 php7.0 libapache2-mod-php vlc libasound2-plugin-equal vim squeezelite npm jq lirc python3-pip

echo "### install dsptoolkit"
cd /home/pi
git clone https://github.com/hifiberry/hifiberry-dsp.git
chmod 755 ./hifiberry-dsp/install-dsptoolkit
./hifiberry-dsp/install-dsptoolkit
mkdir /home/pi/.dsptoolkit
chown pi:pi /home/pi/.dsptoolkit
cd PiDPA/system/
su pi -c "dsptoolkit install-profile migu96.xml"

#echo "### install roon-extension-itroxs"
#cd /home/pi
#git clone https://github.com/bsc101/roon-extension-itroxs.git
#cd roon-extension-itroxs
#npm install
#chown pi:pi .
#cp /home/pi/PiDPA/system/run.sh .
#cd /home/pi/PiDPA/system/
#cp itroxs.service /etc/systemd/system/
#systemctl enable itroxs
#systemctl start itroxs


echo "### install roon-http-api"
cd /home/pi
git clone https://github.com/st0g1e/roon-extension-http-api.git
cd roon-extension-http-api
cp /home/pi/roon-extension-itroxs/run.sh .
npm install
chown pi:pi .
cp /home/pi/PiDPA/system/run.sh .
cd /home/pi/PiDPA/system/
cp roon-http-api.service /etc/systemd/system/
systemctl enable roon-http-api
systemctl start roon-http-api

echo "### install squeezelite service"
systemctl stop squeezelite
systemctl disable squeezelite
cd /home/pi/PiDPA/system/
cp SqueezeLite.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable SqueezeLite
systemctl start SqueezeLite

#echo "### install roonbridge"
#cd /home/pi
#mkdir roon
#cd roon
#wget http://download.roonlabs.com/builds/roonbridge-installer-linuxarmv7hf.sh
#chmod 755 roonbridge-installer-linuxarmv7hf.sh
#./roonbridge-installer-linuxarmv7hf.sh

echo "### install bluetooth receiver"
cd /home/pi
git clone https://github.com/nicokaiser/rpi-audio-receiver.git
cd rpi-audio-receiver/
./install-bluetooth.sh
cd ..
cp PiDPA/system/asoundrc /root/.asoundrc
cp PiDPA/system/bluealsa-aplay.service /etc/systemd/system/
systemctl daemon-reload
systemctl start bt-agent
systemctl start bluealsa-aplay

echo "### check for hifiberry  driver in /boot/config.txt: "
egrep "hifiberry-dacplusdsp$" /boot/config.txt 
if [ $? -eq 1 ];then
	cat /boot/config.txt |grep -v "dtparam=audio=on" |grep -v "dtparam=spi=on" >/tmp/config.txt	
	echo "dtoverlay=hifiberry-dacplusdsp" >>/tmp/config.txt
        echo "dtparam=spi=on" >>/tmp/config.txt
        echo "dtoverlay=disable-wifi" >>/tmp/config.txt
        echo "hdmi_force_hotplug=1" >>/tmp/config.txt
	cp /tmp/config.txt /boot/config.txt
fi

echo "### install irdroid lirc"
cd /home/pi/PiDPA/system/
systemctl stop lircd
systemctl disable lircd
cp HDMISwitch.conf /etc/lirc/lircd.conf.d/
cp TV.lircd.conf /etc/lirc/lircd.conf.d/
cp Lircd.service /etc/systemd/system/
systemctl enable Lircd
systemctl start Lircd

#echo "### install raspotify"
#cd /home/pi/
#curl -sL https://dtcooper.github.io/raspotify/install.sh | sh
#cd /home/pi/PiDPA/system/
#cp asoundrc /etc/asound.conf
#cp raspotify /etc/default/
#systemctl restart raspotify

echo "### set file permissions"
cd /home/pi/PiDPA/
sudo chown -R pi:pi .
chmod 755 bin/*
sudo chown -R www-data:www-data www
sudo chmod 777 www/* 
sudo chmod 755 www/img
sudo chmod 777 www/img/*
sudo usermod -a -G pi www-data
sudo chown pi:pi /home/pi/.dsptoolkit

echo "### install apache config"
printf "do you want to install new apache config? (y/n): "
read a
if [ "$a" == "y" ];then
	cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.sav
	cp /home/pi/PiDPA/system/apache.conf /etc/apache2/sites-available/000-default.conf	
        #rm /etc/apache2/sites-sites-available/
	service apache2 restart 2>/dev/null
fi

echo "### install alsa config"
cd /home/pi/
su pi -c "ln -s PiDPA/system/asoundrc /home/pi/.asoundrc"
#cp system/asoundrc $HOME/.asoundrc





echo
echo "### start kodi and do:"


echo
echo "### Add line: /home/pi/PiDPA/bin/startup.sh to /etc/rc.local"
echo "### Add line: modprobe snd-aloop to /etc/rc.local"
echo
echo "### Add line to /etc/sudoers: "
echo "%pi ALL=(ALL) NOPASSWD: ALL"
echo
echo "### reboot !!!"
