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

# Disable layer slide animation so overlay appears instantly
hyprctl keyword animation "layersIn,0,1,default" 2>/dev/null
hyprctl keyword animation "fadeLayersIn,0,1,default" 2>/dev/null

wl-kbptr -o modes=floating,click -o mode_floating.source=detect &
echo $! > "$PID_FILE"

# Restore animations after wl-kbptr has drawn (50ms is enough)
sleep 0.05
hyprctl keyword animation "layersIn,1,3,menu_decel,slide" 2>/dev/null
hyprctl keyword animation "fadeLayersIn,1,2,menu_decel" 2>/dev/null
