#!/bin/bash
cd "$(dirname "$0")"
cd ..
./bin/kodiRequest.sh pause
ps -ef|grep dmixer|grep -v grep|grep -v default|awk -F' ' '{print $2}'|xargs kill -1

