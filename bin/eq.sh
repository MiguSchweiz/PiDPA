#!/bin/bash
# set homedir
cd "$(dirname "$0")"
cd ..

# Help
if [ "$1" == "-h" ];then
        echo
        echo "Options:"
        echo "   on	enable eq"
        echo "   off	disable eq"
        echo
        exit 0
fi

# min:0 max:24

if [ "$1" == "on" ]; then
        touch .eq
        dsptoolkit tone-control ls 100Hz -- -26db
else
	rm .eq 2>/dev/null
        dsptoolkit tone-control ls 100Hz 0db
fi

