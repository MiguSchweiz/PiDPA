#!/bin/bash
#ps -ef |grep kodi|grep -v grep >/dev/null || sudo -u kodi kodi &
ps -ef |grep kodi_v7.bin|grep -v grep >/dev/null || kodi &
