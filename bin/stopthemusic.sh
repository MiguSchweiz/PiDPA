#!/bin/bash
cd "$(dirname "$0")"
cd ..
./bin/kodiRequest.sh 
ps -ef|grep dmixer|grep -v grep|grep -v default|awk -F' ' '{print $2}'|xargs kill -1

