#!/bin/bash

CONFIG="$HOME/.config/fastfetch/config.jsonc"

# Terminal character cells are ~2x taller than wide.
# To display an image undistorted: cols/rows = (img_w/img_h) * 2
# We fix width at 22 cols and derive the correct row count.
COLS=22
CELL_RATIO=2  # char_height / char_width

# Accept image path as arg or open file picker
if [ -n "$1" ]; then
    IMG="$1"
else
    IMG=$(zenity --file-selection \
        --title="Pick terminal logo image" \
        --file-filter="Images | *.png *.jpg *.jpeg *.webp *.gif" \
        2>/dev/null)
fi

[ -z "$IMG" ] && exit 0
[ ! -f "$IMG" ] && zenity --error --text="File not found: $IMG" && exit 1

# Get image dimensions with magick
DIMS=$(magick identify -format "%w %h" "$IMG" 2>/dev/null)
IMG_W=$(echo $DIMS | cut -d' ' -f1)
IMG_H=$(echo $DIMS | cut -d' ' -f2)

if [ -z "$IMG_W" ] || [ -z "$IMG_H" ] || [ "$IMG_H" -eq 0 ]; then
    ROWS=15
else
    # rows = cols / (img_w/img_h * CELL_RATIO)
    ROWS=$(python3 -c "import math; print(round($COLS / ($IMG_W / $IMG_H * $CELL_RATIO)))")
fi

# Update source path and dimensions in fastfetch config
sed -i "s|\"source\": \".*\"|\"source\": \"$IMG\"|" "$CONFIG"
sed -i "s|\"width\": [0-9]*|\"width\": $COLS|" "$CONFIG"
sed -i "s|\"height\": [0-9]*|\"height\": $ROWS|" "$CONFIG"

zenity --info --title="Terminal logo updated" \
    --text="Logo: $(basename "$IMG")\nSize: ${COLS}×${ROWS} cells\n\nOpen a new terminal to see it." \
    --width=300 2>/dev/null &
