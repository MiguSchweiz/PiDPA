#!/bin/sh
for i in /proc/[0-9]*/fd/*
do
        if readlink $i | grep -q /dev/snd/pcm
        then
                IFS=/; set -- $i; unset IFS; echo $3
        fi
done

