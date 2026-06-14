#!/bin/bash
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"

LOCK_FILE="/tmp/download-mode.pid"

if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    kill "$PID" 2>/dev/null
    rm -f "$LOCK_FILE"
    if command -v hypridle &>/dev/null; then
        hypridle &
    fi
    notify_user --a "System" --i "network-receive" \
                --s "Download Mode OFF" \
                --m "Sleep and power saving restored"
else
    pkill hypridle 2>/dev/null
    systemd-inhibit \
        --what=sleep:idle:handle-lid-switch:handle-suspend-key:handle-hibernate-key \
        --who="Download Mode" \
        --why="Large file download in progress" \
        --mode=block \
        sleep infinity &
    echo $! > "$LOCK_FILE"
    notify_user --a "System" --i "network-receive" \
                --s "Download Mode ON" \
                --m "Sleep blocked — laptop will stay awake"
fi
