#!/bin/bash
ps -ef |grep kodi.bin|grep -v grep >/dev/null || sudo -u kodi kodi &
