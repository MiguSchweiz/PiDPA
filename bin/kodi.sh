#!/bin/bash
exec 2>&1 >/dev/null
cd "$(dirname "$0")"
#ps -ef |grep kodi|grep -v grep >/dev/null || sudo -u kodi kodi &
ps -ef |grep -v grep|grep kodi_v7.bin >/dev/null || kodi &
ps -ef |grep -v grep|grep kodiTitle.sh >/dev/null || ./kodiTitle.sh & 2>&1 >/dev/null
