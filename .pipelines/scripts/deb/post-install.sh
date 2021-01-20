#!/bin/bash

MS_TELEGRAF=ms-telegraf
BIN_DIR=/usr/bin
LOG_DIR=/var/log/$MS_TELEGRAF
SCRIPT_DIR=/usr/lib/$MS_TELEGRAF/scripts
LOGROTATE_DIR=/etc/logrotate.d

function install_init {
    cp -f $SCRIPT_DIR/init.sh /etc/init.d/$MS_TELEGRAF
    chmod +x /etc/init.d/$MS_TELEGRAF
}

function install_systemd {
    cp -f $SCRIPT_DIR/$MS_TELEGRAF.service $1
    systemctl enable $MS_TELEGRAF || true
    systemctl daemon-reload || true
}

function install_update_rcd {
    update-rc.d $MS_TELEGRAF defaults
}

function install_chkconfig {
    chkconfig --add $MS_TELEGRAF
}

# Remove legacy symlink, if it exists
if [[ -L /etc/init.d/$MS_TELEGRAF ]]; then
    rm -f /etc/init.d/$MS_TELEGRAF
fi
# Remove legacy symlink, if it exists
if [[ -L /etc/systemd/system/$MS_TELEGRAF.service ]]; then
    rm -f /etc/systemd/system/$MS_TELEGRAF.service
fi

# Add defaults file, if it doesn't exist
if [[ ! -f /etc/default/$MS_TELEGRAF ]]; then
    touch /etc/default/$MS_TELEGRAF
fi

# Add .d configuration directory
if [[ ! -d /etc/$MS_TELEGRAF/telegraf.d ]]; then
    mkdir -p /etc/$MS_TELEGRAF/telegraf.d
fi

# If 'telegraf.conf' is not present use package's sample (fresh install)
if [[ ! -f /etc/$MS_TELEGRAF/telegraf.conf ]] && [[ -f /etc/$MS_TELEGRAF/telegraf.conf.sample ]]; then
   cp /etc/$MS_TELEGRAF/telegraf.conf.sample /etc/$MS_TELEGRAF/telegraf.conf
fi

test -d $LOG_DIR || mkdir -p $LOG_DIR
chown -R -L telegraf:telegraf $LOG_DIR
chmod 755 $LOG_DIR

if [[ "$(readlink /proc/1/exe)" == */systemd ]]; then
	install_systemd /lib/systemd/system/$MS_TELEGRAF.service
	deb-systemd-invoke restart $MS_TELEGRAF.service || echo "WARNING: systemd not running."
else
	# Assuming SysVinit
	install_init
	# Run update-rc.d or fallback to chkconfig if not available
	if which update-rc.d &>/dev/null; then
		install_update_rcd
	else
		install_chkconfig
	fi
	invoke-rc.d $MS_TELEGRAF restart
fi
