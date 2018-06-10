#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

a=$1
b=$2

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
			echo mute && touch .hmute
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
                amixer  -Dhw:RPiCirrus cget name='AIF2TX1 Input 1'|grep values=0 2>&1 >/dev/null
                if [ $? -eq 1 ];then
			echo mute && touch .smute
                        amixer -q  -Dhw:RPiCirrus cset name='AIF2TX1 Input 1' None
                        amixer -q  -Dhw:RPiCirrus cset name='AIF2TX2 Input 1' None
                else
			rm .smute 2>/dev/null
                        amixer -q  -Dhw:RPiCirrus cset name='AIF2TX1 Input 1' EQ1
                        amixer -q  -Dhw:RPiCirrus cset name='AIF2TX2 Input 1' EQ2
                fi
        else
		vol=`amixer -Dhw:RPiCirrus cget name='AIF2TX1 Input 1 Volume'| grep ": values"|awk -F'=' '{print $2}'`
		nv=`expr $vol $b 2`
		[ $nv -ge 0 ] &&
		amixer -q -Dhw:RPiCirrus cset name='AIF2TX1 Input 1 Volume' $nv
		amixer -q -Dhw:RPiCirrus cset name='AIF2TX2 Input 1 Volume' $nv
		echo $nv
	fi
fi

