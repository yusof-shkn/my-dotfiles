#!/bin/bash

# Wait for Hyprland and desktop to finish initializing
sleep 6

choice=$(printf "Yes\nNo" | rofi -dmenu -i -p " Open workspace apps?")

[[ "$choice" != "Yes" ]] && exit 0

# Workspace 1: terminal + lan-mouse GUI
hyprctl dispatch exec "[workspace 1 silent] kitty"
sleep 0.4
hyprctl dispatch exec "[workspace 1 silent] lan-mouse"
sleep 0.4

# Workspace 2: VS Code
hyprctl dispatch exec "[workspace 2 silent] code"
sleep 0.4

# Workspace 3: Chrome
hyprctl dispatch exec "[workspace 3 silent] google-chrome-stable"
sleep 0.4

# Workspace 4: Telegram
hyprctl dispatch exec "[workspace 4 silent] /usr/bin/Telegram"
sleep 0.4

# Workspace 5: Spotify
hyprctl dispatch exec "[workspace 5 silent] flatpak run com.spotify.Client"
