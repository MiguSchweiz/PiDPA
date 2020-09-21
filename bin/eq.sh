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
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B1 Volume' 0
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B2 Volume' 12 
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B3 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B4 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B5 Volume' 12

        amixer -q -Dhw:RPiCirrus cset name='EQ2 B1 Volume' 0
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B2 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B3 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B4 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B5 Volume' 12
else
	rm .eq 2>/dev/null
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B1 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B2 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B3 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B4 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ1 B5 Volume' 12

        amixer -q -Dhw:RPiCirrus cset name='EQ2 B1 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B2 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B3 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B4 Volume' 12
        amixer -q -Dhw:RPiCirrus cset name='EQ2 B5 Volume' 12
fi

