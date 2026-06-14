#!/bin/bash
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"

if pgrep -x "plover" > /dev/null; then
    pkill -x "plover"
    notify_user --a "Plover" --i "input-keyboard" \
                --s "Steno disabled" \
                --m "Plover has been stopped"
else
    plover &
    notify_user --a "Plover" --i "input-keyboard" \
                --s "Steno enabled" \
                --m "Plover is now running"
fi
