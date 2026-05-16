#!/bin/bash

REPO="$HOME/my-dotfiles"
DOTFILES_SRC="$HOME/.mydotfiles/com.ml4w.dotfiles.stable"

cd "$REPO" || exit 1

# Sync entire dotfiles tree (excluding large/generated dirs)
rsync -a --delete \
    --exclude='.config/ml4w/wallpapers/' \
    --exclude='.config/waypaper/' \
    --exclude='.config/ml4w/colors/cache/' \
    "$DOTFILES_SRC/" "./dotfiles/"

# Nothing changed → exit silently
if git diff --quiet && git diff --cached --quiet; then
    echo "Already up to date."
    exit 0
fi

git add .
git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push

echo "Pushed to GitHub."
