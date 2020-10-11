#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..
# volume limit
vl="3dB"

exec 2>/dev/null
a=$1
hp=0
mute=0

echo $a | egrep "+$|-|m|um|hp" >/dev/null || a="-h"

# Help
if [ "$a" == "-h" ];then
        echo
        echo "Usage: setvol.sh <+|-|m|um|hp> "
        echo "Options:"
        echo "   +      increase volume"
        echo "   -      decrease volume"
        echo "   m      mute volume"
        echo "   um     unmute volume"
        echo "   hp     toggle headphones/speaker"
        echo
        exit 0
fi

if [ $a == "+" ]; then
    vol=`amixer  -Dhw:sndrpihifiberry cget name='DSPVolume'| grep ": values"|awk -F'=' '{print $2}'|awk -F',' '{print $1}'`   
    
    if [ $vol -lt 255 ]; then
        nv=`expr $vol + 10`
    elif [ $vol -ge 255 ]; then
        nv=250
    fi
    [ $nv -ge 255 ] && nv=100
    amixer  -Dhw:sndrpihifiberry cset name='DSPVolume' $nv >/dev/null
elif [ $a == "-" ]; then
    vol=`amixer  -Dhw:sndrpihifiberry cget name='DSPVolume'| grep ": values"|awk -F'=' '{print $2}'|awk -F',' '{print $1}'`
    if [ $vol -gt 0 ]; then
        nv=`expr $vol - 10`
    elif [ $vol -le 0 ]; then
        nv=0
    fi
    [ $nv -le 0 ] && nv=0
    amixer  -Dhw:sndrpihifiberry cset name='DSPVolume' $nv >/dev/null
elif [ $a == "m" ]; then
    dsptoolkit set-limit 0% >/dev/null
    touch .mute && mute=1
elif [ $a == "um" ]; then
    dsptoolkit set-limit 3dB >/dev/null
    rm .mute 2>/dev/null
elif [ $a == "hp" ]; then
    ls .hp >/dev/null
    if [ $? -eq 2 ];then
        touch .hp && hp=1
        # switch on headhones on dacmagic
        echo -n -e '\xA0\x01\x01\xA2'>/dev/ttyUSB0
    else
        rm .hp >/dev/null
        echo -n -e '\xA0\x01\x00\xA1'>/dev/ttyUSB0
    fi
fi

# set .vlevels
ls .hp >/dev/null && hp=1
ls .mute >/dev/null && mute=1

src=`cat www/status`
ls .vlevels 2>&1>/dev/null && vl=`cat .vlevels | grep $src`
echo $vl|egrep "s_|a_" >/dev/null
if [ $? -eq 1 ];then
        sv=50
        hv=100
else
        # <src>;<svol>;<hvol>;<mute>;<hp>
        sv=`echo $vl | awk -F';' '{ print $2 }'`
        hv=`echo $vl | awk -F';' '{ print $3 }'`
fi
if [ $a == "+" ]||[ $a == "-" ]; then
    [ $hp -eq 0 ] && sv=$nv
    [ $hp -eq 1 ] && hv=$nv
    echo $nv
fi
    
cat .vlevels|grep -v $src";" > .vlevels.sav
echo $src";"$sv";"$hv";"$mute";"$hp >> .vlevels.sav
mv .vlevels.sav .vlevels
