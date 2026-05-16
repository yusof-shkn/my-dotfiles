#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_SRC="$REPO_DIR/dotfiles"
DOTFILES_DEST="$HOME/.mydotfiles/com.ml4w.dotfiles.stable"

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

step() { echo -e "\n${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}  [!]${NC} $1"; }

# ── 1. Install yay ────────────────────────────────────────────────────────────
step "Checking for yay (AUR helper)..."
if ! command -v yay &>/dev/null; then
    step "Installing yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay-install
    cd /tmp/yay-install && makepkg -si --noconfirm
    cd "$REPO_DIR"
    rm -rf /tmp/yay-install
else
    echo "  yay already installed."
fi

# ── 2. Install packages ───────────────────────────────────────────────────────
step "Installing official packages..."
grep -v '^#' "$REPO_DIR/packages.txt" | grep -v '^$' | xargs yay -S --needed --noconfirm

step "Installing AUR packages..."
grep -v '^#' "$REPO_DIR/packages-aur.txt" | grep -v '^$' | xargs yay -S --needed --noconfirm

# ── 3. Deploy dotfiles ────────────────────────────────────────────────────────
step "Deploying dotfiles to $DOTFILES_DEST..."
mkdir -p "$DOTFILES_DEST"
rsync -a --delete \
    --exclude='.config/ml4w/wallpapers/' \
    --exclude='.config/waypaper/' \
    "$DOTFILES_SRC/" "$DOTFILES_DEST/"

# Make all scripts executable
find "$DOTFILES_DEST/.config/hypr/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find "$DOTFILES_DEST/.config/ml4w" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find "$DOTFILES_DEST/.config/waybar" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# ── 4. Symlink ~/.config entries ──────────────────────────────────────────────
step "Creating ~/.config symlinks..."
CONFIGS=(
    bashrc btop chromium-flags.conf edge-flags.conf fastfetch fish
    gtk-3.0 gtk-4.0 hypr kitty matugen ml4w ml4w-dotfiles-settings
    nwg-dock-hyprland ohmyposh qt6ct quickshell rofi sidepad swaync
    vim walker waybar waypaper wlogout xsettingsd zshrc
)

mkdir -p "$HOME/.config"
for cfg in "${CONFIGS[@]}"; do
    src="$DOTFILES_DEST/.config/$cfg"
    dst="$HOME/.config/$cfg"
    if [ -e "$src" ]; then
        rm -rf "$dst"
        ln -sf "$src" "$dst"
        echo "  linked: ~/.config/$cfg"
    fi
done

# ── 5. Symlink home dotfiles ──────────────────────────────────────────────────
step "Creating home directory symlinks..."
for f in .bashrc .zshrc .gtkrc-2.0 .Xresources; do
    src="$DOTFILES_DEST/$f"
    dst="$HOME/$f"
    if [ -f "$src" ]; then
        rm -f "$dst"
        ln -sf "$src" "$dst"
        echo "  linked: ~/$f"
    fi
done

# ── 6. Create default wallpaper folder ───────────────────────────────────────
step "Creating wallpaper folder..."
mkdir -p "$HOME/Pictures/Wallpapers"
warn "Add your wallpapers to ~/Pictures/Wallpapers/, then run: waypaper"

# ── 7. Enable system services ─────────────────────────────────────────────────
step "Enabling system services..."
sudo systemctl enable --now NetworkManager 2>/dev/null || true
sudo systemctl enable --now bluetooth 2>/dev/null || true

# ── 8. Done ───────────────────────────────────────────────────────────────────
step "Installation complete!"
echo ""
echo "Manual steps remaining:"
echo "  1. Install oh-my-zsh:"
echo '     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
echo "  2. Set your wallpaper: waypaper"
echo "  3. Configure displays: nwg-displays"
echo "  4. Log out and select Hyprland in your display manager."
echo ""
