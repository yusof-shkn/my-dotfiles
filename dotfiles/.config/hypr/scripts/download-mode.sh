#!/bin/bash
# Toggle download mode: blocks sleep/suspend and keeps background processes unrestricted
LOCK_FILE="/tmp/download-mode.pid"

if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    kill "$PID" 2>/dev/null
    rm -f "$LOCK_FILE"
    # Restart hypridle
    if command -v hypridle &>/dev/null; then
        hypridle &
    fi
    notify-send "Download Mode OFF" "Sleep and power saving restored" \
        --icon=network-receive --urgency=normal
else
    # Kill hypridle so screen doesn't lock/idle
    pkill hypridle 2>/dev/null
    # Hold a systemd sleep inhibitor in the background
    systemd-inhibit \
        --what=sleep:idle:handle-lid-switch:handle-suspend-key:handle-hibernate-key \
        --who="Download Mode" \
        --why="Large file download in progress" \
        --mode=block \
        sleep infinity &
    echo $! > "$LOCK_FILE"
    notify-send "Download Mode ON" "Sleep blocked — laptop will stay awake for your download" \
        --icon=network-receive --urgency=normal
fi
