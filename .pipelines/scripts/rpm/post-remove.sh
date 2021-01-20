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

if [[ -f /etc/redhat-release ]] || [[ -f /etc/SuSE-release ]]; then
    # RHEL-variant logic
    if [[ "$1" = "0" ]]; then
        # InfluxDB is no longer installed, remove from init system
        rm -f /etc/default/$MS_TELEGRAF

        if [[ "$(readlink /proc/1/exe)" == */systemd ]]; then
            disable_systemd /usr/lib/systemd/system/$MS_TELEGRAF.service
        else
            # Assuming sysv
            disable_chkconfig
        fi
    fi
elif [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" = "amzn" ]] && [[ "$1" = "0" ]]; then
        # InfluxDB is no longer installed, remove from init system
        rm -f /etc/default/$MS_TELEGRAF

        if [[ "$NAME" = "Amazon Linux" ]]; then
            # Amazon Linux 2+ logic
            disable_systemd /usr/lib/systemd/system/$MS_TELEGRAF.service
        elif [[ "$NAME" = "Amazon Linux AMI" ]]; then
            # Amazon Linux logic
            disable_chkconfig
        fi
    elif [[ "$NAME" = "Solus" ]]; then
        rm -f /etc/default/$MS_TELEGRAF
        disable_systemd /usr/lib/systemd/system/$MS_TELEGRAF.service
    fi
fi
