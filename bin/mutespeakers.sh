#!/bin/bash
cd "$(dirname "$0")"
cd ..

function chkodi() {
    cat www/status|grep a_5 >/dev/null 
    return $?
}

if [ "$1" == "mute" ]; then
    if [ ! -f .hp ]; then
        ./bin/setvol.sh s mt
        chkodi && ./bin/kodiRequest.sh pause
    fi
else
    ./bin/setvol.sh s umt
    chkodi && ./bin/kodiRequest.sh play
fi
