#!/bin/bash

# Use wofi or rofi
LAUNCHER="rofi -dmenu -i -p"

MENU() {
  eval $LAUNCHER "\"$2\""
}

# Step 1: Get all available sink names (just the IDs)
SINKS=$(pactl list sinks | grep 'Name:' | awk '{print $2}')

# Step 2: Show in menu
SELECTED=$(echo "$SINKS" | MENU)
[[ -z "$SELECTED" ]] && exit

# Step 3: Set the selected sink as default
pactl set-default-sink "$SELECTED"

# Step 4: Move all current playing streams to the new sink
for input in $(pactl list short sink-inputs | awk '{print $1}'); do
  pactl move-sink-input "$input" "$SELECTED"
done

