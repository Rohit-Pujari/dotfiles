#!/bin/bash

# Rofi power menu
choice=$(echo -e " Lock\n󰤄 Suspend\n󰍃 Logout\n󰜉 Reboot\n Shutdown" | \
  rofi -dmenu -i -p "Power Menu" -theme-str 'window { width: 400px; }')

case "$choice" in
  " Lock")
    hyprlock
    ;;
  "󰤄 Suspend")
    systemctl suspend
    ;;
  "󰍃 Logout")
    hyprctl dispatch exit
    ;;
  "󰜉 Reboot")
    systemctl reboot
    ;;
  " Shutdown")
    systemctl poweroff
    ;;
  *)
    exit 0
    ;;
esac
