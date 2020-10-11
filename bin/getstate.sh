#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

[ -f .eq ] && eq=0 || eq=1
[ -f .mute ] && m=0 || m=1
[ -f .hp ] && hp=1 || hp=0
fx1="false"
fx2="false"
cat .fx|grep norm >/dev/null && fx1="true"
cat .fx|grep cf >/dev/null && fx2="true"
p=`cat www/status`
echo $p";"$eq";"$m";"$hp";"$fx1";"$fx2
