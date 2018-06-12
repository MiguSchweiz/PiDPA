#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

[ -f .eq ] && eq=0 || eq=1
[ -f .hmute ] && hm=0 || hm=1
[ -f .smute ] && sm=0 || sm=1
p=`cat www/status`
echo $p";"$eq";"$sm";"$hm
