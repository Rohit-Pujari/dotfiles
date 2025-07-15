#!/bin/bash
scan_and_show_menu() {
    NETWORKS=$(nmcli -f SSID,SIGNAL dev wifi list | awk 'NR>1 && $1!="" {print $1}' | sort -u)
    OPTIONS=$(echo -e "🔄 Rescan\n$NETWORKS")
    echo "$OPTIONS" | rofi -dmenu -p "Select WiFi Network"
}

connect_wifi() {
    local SSID="$1"

    if nmcli connection show | grep -qw "$SSID"; then
        nmcli connection up "$SSID" && notify-send "WiFi" "Connected to $SSID" && return 0
        # If saved connection fails, delete it and retry
        nmcli connection delete "$SSID" >/dev/null 2>&1
        notify-send "WiFi" "Failed to connect. Retrying..."
    fi

    # Ask password loop
    while true; do
        PASSWORD=$(rofi -dmenu -password -p "Enter password for $SSID")
        [[ -z "$PASSWORD" ]] && exit 1

        nmcli dev wifi connect "$SSID" password "$PASSWORD" && \
        notify-send "WiFi" "Connected to $SSID" && return 0

        # If connection fails again
        nmcli connection delete "$SSID" >/dev/null 2>&1
        notify-send "WiFi" "Wrong password. Try again."
    done
}

while true; do
    CHOSEN_SSID=$(scan_and_show_menu)
    [[ -z "$CHOSEN_SSID" ]] && exit

    if [[ "$CHOSEN_SSID" == "🔄 Rescan" ]]; then
        continue
    fi

    connect_wifi "$CHOSEN_SSID"
    break
done
