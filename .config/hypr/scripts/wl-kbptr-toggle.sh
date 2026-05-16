#!/bin/bash
PID_FILE="/tmp/wl-kbptr.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm "$PID_FILE"
        exit 0
    else
        rm "$PID_FILE"
    fi
fi

wl-kbptr -o modes=floating,click -o mode_floating.source=detect &
echo $! > "$PID_FILE"
