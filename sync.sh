#!/bin/bash

REPO="$HOME/my-dotfiles"

# All tracked files: source → repo destination
declare -A FILES=(
    ["$HOME/.config/hypr/conf/custom.conf"]=".config/hypr/conf/custom.conf"
    ["$HOME/.config/hypr/scripts/set-terminal-logo.sh"]=".config/hypr/scripts/set-terminal-logo.sh"
    ["$HOME/.config/hypr/scripts/cursor-daemon.py"]=".config/hypr/scripts/cursor-daemon.py"
    ["$HOME/.config/hypr/scripts/cursor-send.sh"]=".config/hypr/scripts/cursor-send.sh"
    ["$HOME/.config/hypr/scripts/wl-kbptr-toggle.sh"]=".config/hypr/scripts/wl-kbptr-toggle.sh"
    ["$HOME/.config/fastfetch/config.jsonc"]=".config/fastfetch/config.jsonc"
    ["$HOME/.config/zshrc/20-customization"]=".config/zshrc/20-customization"
    ["$HOME/.config/ml4w/settings/browser.sh"]=".config/ml4w/settings/browser.sh"
    ["$HOME/.config/rofi/config.rasi"]=".config/rofi/config.rasi"
)

cd "$REPO" || exit 1

# Copy latest versions into the repo
for src in "${!FILES[@]}"; do
    dst="${FILES[$src]}"
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst" 2>/dev/null
done

# Sync entire waybar themes directory
rsync -a --delete "$HOME/.config/waybar/themes/" ".config/waybar/themes/"

# Nothing changed → exit silently
if git diff --quiet && git diff --cached --quiet; then
    echo "Already up to date."
    exit 0
fi

git add .
git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push

echo "Pushed to GitHub."
