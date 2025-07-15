#!/bin/bash

# Find all wallpapers
WALLPAPERS=$(find .config/hypr/wallpapers -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.bmp" -o -iname "*.webp" \))

# Use Rofi to select one
SELECTED_WALLPAPER=$(echo "$WALLPAPERS" | rofi -dmenu -p "Select Wallpaper")

# If one was selected
if [ -n "$SELECTED_WALLPAPER" ]; then
    # Set theme with pywal
    wal -i "$SELECTED_WALLPAPER"

    # Kill existing hyprpaper and restart
    killall hyprpaper 2>/dev/null

    # Write a hyprpaper config file
    cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = $SELECTED_WALLPAPER
wallpaper = ,$SELECTED_WALLPAPER
EOF

    # Start hyprpaper
    hyprpaper &

    # Restart waybar
    killall waybar 2>/dev/null
    waybar &

    # Restart swaync
    killall swaync 2>/dev/null
    swaync &

    # Reload Hyprland
    hyprctl reload
else
    echo "No wallpaper selected!"
fi
