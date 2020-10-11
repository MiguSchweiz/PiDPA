# set homedir
exec 2>/dev/null
ps -ef |grep setvlevels|grep -v grep >/dev/null && exit 1

cd "$(dirname "$0")"
cd ..

src=`cat www/status`
ls .vlevels 2>&1>/dev/null && vl=`cat .vlevels | grep $src`
echo $vl|egrep "s_|a_" >/dev/null
if [ $? -eq 1 ];then
    cat .vlevels|grep -v $src";" > .vlevels.sav
    echo $src";100;150;0;1" >> .vlevels.sav
    mv .vlevels.sav .vlevels
    vl=`cat .vlevels | grep $src`
fi

ls .hp >/dev/null  
if [ $? -eq 0 ]; then 
    v=`echo $vl | awk -F';' '{ print $3 }'`
else
    v=`echo $vl | awk -F';' '{ print $2 }'`
fi

amixer  -Dhw:sndrpihifiberry cset name='DSPVolume' $v >/dev/null







