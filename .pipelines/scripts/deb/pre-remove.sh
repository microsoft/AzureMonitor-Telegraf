#!/bin/bash

BIN_DIR=/usr/bin
MS_TELEGRAF='ms-telegraf'

if [[ "$(readlink /proc/1/exe)" == */systemd ]]; then
	deb-systemd-invoke stop $MS_TELEGRAF.service
else
	# Assuming sysv
	invoke-rc.d $MS_TELEGRAF stop
fi
