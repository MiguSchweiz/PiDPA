#!/bin/bash
ps -ef |grep kodi.bin|grep -v grep >/dev/null ||kodi &
