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
# Use windowrulev2 so the rule applies to the child window, not just the wrapper process
hyprctl keyword windowrulev2 "workspace 2 silent,class:^(Code)$"
hyprctl dispatch exec "code"
sleep 0.4

# Workspace 3: Chrome
hyprctl dispatch exec "[workspace 3 silent] google-chrome-stable"
sleep 0.4

# Workspace 4: Telegram
hyprctl dispatch exec "[workspace 4 silent] /usr/bin/Telegram"
sleep 0.4

# Workspace 5: Spotify
# Same wrapper issue as VS Code — use windowrulev2 by class
hyprctl keyword windowrulev2 "workspace 5 silent,class:^(spotify)$"
hyprctl dispatch exec "flatpak run com.spotify.Client"
