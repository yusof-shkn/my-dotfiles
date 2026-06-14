#!/usr/bin/env bash
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"

cache_file="$HOME/.cache/toggle_animation"

if [[ $(cat $HOME/.config/hypr/conf/animation.conf) == *"disabled"* ]]; then
    notify_user --a "System" --i "preferences-system" \
                --s "Animations blocked" \
                --m "Disabled by animation config — cannot toggle."
else
    if [ -f "$cache_file" ]; then
        hyprctl keyword animations:enabled true
        rm "$cache_file"
        notify_user --a "System" --i "preferences-system" \
                    --s "Animations enabled"
    else
        hyprctl keyword animations:enabled false
        touch "$cache_file"
        notify_user --a "System" --i "preferences-system" \
                    --s "Animations disabled"
    fi
fi
