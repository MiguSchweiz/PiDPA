#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

[ -f .eq ] && eq=0 || eq=1
[ -f .hmute ] && hm=0 || hm=1
[ -f .hp ] && sm=0 || sm=1
fx1="false"
fx2="false"
cat .fx|grep norm >/dev/null && fx1="true"
cat .fx|grep cf >/dev/null && fx2="true"
p=`cat www/status`
echo $p";"$eq";"$sm";"$hm";"$fx1";"$fx2
