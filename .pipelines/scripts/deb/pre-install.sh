#!/bin/bash

MS_TELEGRAF=ms-telegraf

if ! grep "^telegraf:" /etc/group &>/dev/null; then
    groupadd -r telegraf
fi

if ! id telegraf &>/dev/null; then
    useradd -r -M telegraf -s /bin/false -d /etc/$MS_TELEGRAF -g telegraf
fi

if [[ -d /etc/opt/$MS_TELEGRAF ]]; then
    # Legacy configuration found
    if [[ ! -d /etc/$MS_TELEGRAF ]]; then
        # New configuration does not exist, move legacy configuration to new location
        echo -e "Please note, Telegraf's configuration is now located at '/etc/${MS_TELEGRAF}' (previously '/etc/opt/${MS_TELEGRAF}')."
        mv -vn /etc/opt/$MS_TELEGRAF /etc/$MS_TELEGRAF

        if [[ -f /etc/$MS_TELEGRAF/telegraf.conf ]]; then
            backup_name="telegraf.conf.$(date +%s).backup"
            echo "A backup of your current configuration can be found at: /etc/${MS_TELEGRAF}/${backup_name}"
            cp -a "/etc/${MS_TELEGRAF}/telegraf.conf" "/etc/${MS_TELEGRAF}/${backup_name}"
        fi
    fi
fi
