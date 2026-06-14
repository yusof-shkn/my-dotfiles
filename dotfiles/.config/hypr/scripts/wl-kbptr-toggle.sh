#!/bin/bash
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"

PID_FILE="/tmp/wl-kbptr.pid"

_disable_anim() {
    hyprctl keyword animation "layersIn,0,1,default"      2>/dev/null
    hyprctl keyword animation "layersOut,0,1,default"     2>/dev/null
    hyprctl keyword animation "fadeLayersIn,0,1,default"  2>/dev/null
    hyprctl keyword animation "fadeLayersOut,0,1,default" 2>/dev/null
}

_restore_anim() {
    hyprctl keyword animation "layersIn,1,3,menu_decel,slide"  2>/dev/null
    hyprctl keyword animation "layersOut,1,1.6,menu_accel"     2>/dev/null
    hyprctl keyword animation "fadeLayersIn,1,2,menu_decel"    2>/dev/null
    hyprctl keyword animation "fadeLayersOut,1,4.5,menu_accel" 2>/dev/null
}

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        _disable_anim
        kill "$PID"
        rm "$PID_FILE"
        sleep 0.05
        _restore_anim
        notify_user --a "System" --i "input-keyboard" \
                    --s "Keyboard pointer disabled"
        exit 0
    else
        rm "$PID_FILE"
    fi
fi

_disable_anim
wl-kbptr -o modes=floating,click -o mode_floating.source=detect &
echo $! > "$PID_FILE"
sleep 0.05
_restore_anim
notify_user --a "System" --i "input-keyboard" \
            --s "Keyboard pointer enabled" \
            --m "Use Alt+i/k/j/l to move the cursor"
