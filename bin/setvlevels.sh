# set homedir
ps -ef |grep setvlevels|grep -v grep >/dev/null && exit 1

cd "$(dirname "$0")"
cd ..

src=`cat www/status`
ls .vlevels 2>&1>/dev/null && vl=`cat .vlevels | grep $src`
echo $vl|egrep "s_|a_" >/dev/null
if [ $? -eq 1 ];then
	cat .vlevels|grep -v $src";" > .vlevels.sav
	echo $src";0;1;15;80" >> .vlevels.sav
	mv .vlevels.sav .vlevels
	exit 1
else
        #sm=`echo $vl | awk -F';' '{ print $2 }'`
        #hm=`echo $vl | awk -F';' '{ print $3 }'`
        sv=`echo $vl | awk -F';' '{ print $4 }'`
        hv=`echo $vl | awk -F';' '{ print $5 }'`
fi
amixer -q -Dhw:RPiCirrus cset name='AIF2TX1 Input 1 Volume' $sv
amixer -q -Dhw:RPiCirrus cset name='AIF2TX2 Input 1 Volume' $sv

amixer -q -Dhw:RPiCirrus cset name='HPOUT1 Digital Volume' $hv








