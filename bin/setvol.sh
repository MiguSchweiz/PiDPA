#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

a=$1
b=$2
smute=0
hmute=0

echo $a | egrep "^h$|^s$" >/dev/null || a="-h"
echo $b | egrep "^m$|^\+$|^-$" >/dev/null || a="-h"

# Help
if [ "$a" == "-h" ];then
        echo
        echo "Usage: setvol.sh <h|s> <+|-|m>"
	echo "Options:"
        echo "   h	set headphones volume"
        echo "   s	set speaker volume (SPDIF out)"
	echo "   +	increase volume"	 
        echo "   -	decrease volume"
        echo "   m	toggle mute volume"
        echo
        exit 0
fi

if [ $a == "h" ];then
	if [ "$b" == "m" ];then
		amixer  -Dhw:RPiCirrus cget name='HPOUT1L Input 1'|grep values=0 2>&1 >/dev/null
		if [ $? -eq 1 ];then
			touch .hmute && hmute=1
	        	amixer -q  -Dhw:RPiCirrus cset name='HPOUT1L Input 1' None
       			amixer -q  -Dhw:RPiCirrus cset name='HPOUT1R Input 1' None
		else
			rm .hmute 2>/dev/null
			amixer -q  -Dhw:RPiCirrus cset name='HPOUT1L Input 1' EQ1
			amixer -q  -Dhw:RPiCirrus cset name='HPOUT1R Input 1' EQ2
		fi
	else
		vol=`amixer -Dhw:RPiCirrus cget name='HPOUT1 Digital Volume'| grep ": values"|awk -F'=' '{print $2}'|awk -F',' '{print $1}'`
		nv=`expr $vol $b 4`
		[ $nv -ge 0 ] &&
		amixer -q -Dhw:RPiCirrus cset name='HPOUT1 Digital Volume' $nv
		echo $nv
	fi
elif [ $a == "s" ];then
	if [ "$b" == "m" ];then
                # amixer  -Dhw:RPiCirrus cget name='AIF2TX1 Input 1'|grep values=0 2>&1 >/dev/null
		ls .smute 2>&1 >/dev/null
                if [ $? -eq 2 ];then
			touch .smute && smute=1
                        # amixer -q  -Dhw:RPiCirrus cset name='AIF2TX1 Input 1' None
                        # amixer -q  -Dhw:RPiCirrus cset name='AIF2TX2 Input 1' None
			# switch on headhones on dacmagic
			echo -n -e '\xA0\x01\x01\xA2'>/dev/ttyUSB0
                else
			rm .smute 2>/dev/null
                        # amixer -q  -Dhw:RPiCirrus cset name='AIF2TX1 Input 1' EQ1
                        # amixer -q  -Dhw:RPiCirrus cset name='AIF2TX2 Input 1' EQ2
			# switch off headhones on dacmagic
			echo -n -e '\xA0\x01\x00\xA1'>/dev/ttyUSB0
                fi
		./bin/fx.sh checkdrc
        else
		vol=`amixer -Dhw:RPiCirrus cget name='AIF2TX1 Input 1 Volume'| grep ": values"|awk -F'=' '{print $2}'`
		nv=`expr $vol $b 2`
		[ $nv -lt 0 ] && nv=0
		amixer -q -Dhw:RPiCirrus cset name='AIF2TX1 Input 1 Volume' $nv
		amixer -q -Dhw:RPiCirrus cset name='AIF2TX2 Input 1 Volume' $nv
		echo $nv
	fi
fi

# set .vlevels
src=`cat www/status`
ls .vlevels 2>&1>/dev/null && vl=`cat .vlevels | grep $src`
echo $vl|egrep "s_|a_" >/dev/null
if [ $? -eq 1 ];then
	sm=0
	hm=1
	sv=15
	hv=80
else
	sm=`echo $vl | awk -F';' '{ print $2 }'`
	hm=`echo $vl | awk -F';' '{ print $3 }'`
	sv=`echo $vl | awk -F';' '{ print $4 }'`
	hv=`echo $vl | awk -F';' '{ print $5 }'`
fi
if [ $a == "s" ] && [ $b == "m" ];then
	sm=$smute
elif [ $a == "h" ] && [ $b == "m" ];then
	hm=$hmute
elif [ $a == "s" ];then
	sv=$nv
elif [ $a == "h" ];then
	hv=$nv
fi
cat .vlevels|grep -v $src";" > .vlevels.sav
echo $src";"$sm";"$hm";"$sv";"$hv >> .vlevels.sav
mv .vlevels.sav .vlevels



