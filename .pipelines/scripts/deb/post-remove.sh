#!/bin/bash

MS_TELEGRAF=ms-telegraf

function disable_systemd {
    systemctl disable $MS_TELEGRAF
    rm -f $1
}

function disable_update_rcd {
    update-rc.d -f $MS_TELEGRAF remove
    rm -f /etc/init.d/$MS_TELEGRAF
}

function disable_chkconfig {
    chkconfig --del $MS_TELEGRAF
    rm -f /etc/init.d/$MS_TELEGRAF
}

if [ "$1" == "remove" -o "$1" == "purge" ]; then
	# Remove/purge
	rm -f /etc/default/$MS_TELEGRAF

	if [[ "$(readlink /proc/1/exe)" == */systemd ]]; then
		disable_systemd /lib/systemd/system/$MS_TELEGRAF.service
	else
		# Assuming sysv
		# Run update-rc.d or fallback to chkconfig if not available
		if which update-rc.d &>/dev/null; then
			disable_update_rcd
		else
			disable_chkconfig
		fi
	fi
fi
