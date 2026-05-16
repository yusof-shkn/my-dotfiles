# My Dotfiles

Full portable Hyprland setup — clone, run `install.sh`, done.

Built on top of [ML4W dotfiles](https://github.com/mylinuxforwork/dotfiles) with personal customizations.

## What's inside

| Directory / File | Description |
|------------------|-------------|
| `dotfiles/` | Full config tree (deployed to `~/.mydotfiles/com.ml4w.dotfiles.stable/`) |
| `packages.txt` | Official pacman packages |
| `packages-aur.txt` | AUR packages (installed via yay) |
| `install.sh` | Full install script |
| `sync.sh` | Push local changes back to this repo |

## Fresh install

```bash
git clone https://github.com/yusof-shkn/my-dotfiles.git ~/my-dotfiles
cd ~/my-dotfiles
bash install.sh
```

The script will:
1. Install `yay` (AUR helper) if missing
2. Install all packages from `packages.txt` and `packages-aur.txt`
3. Deploy `dotfiles/` to `~/.mydotfiles/com.ml4w.dotfiles.stable/`
4. Symlink `~/.config/*` and home dotfiles (`~/.zshrc`, `~/.bashrc`, etc.)
5. Install `oh-my-zsh` + plugins (`zsh-autosuggestions`, `fast-syntax-highlighting`)
6. Install `oh-my-posh` via its install script
7. Set zsh as the default shell
8. Add Flatpak remotes and install `com.ml4w.hyprlandsettings` + Brave
9. Enable `NetworkManager` and `bluetooth` services

### Manual steps after install

```bash
# Add a wallpaper (ml4w uses this as the default)
cp your-wallpaper.jpg ~/.config/ml4w/wallpapers/default.jpg

# Configure displays
nwg-displays
```

Then log out and select **Hyprland** in your display manager.

---

## Keybinds

| Shortcut | Action |
|----------|--------|
| Super + L | Lock screen (hyprlock — live screenshot background) |
| Super + P | Screenshot menu |
| Super + D | App launcher |
| Super + Return | Terminal (kitty) |
| Super + W | Browser (Chrome) |
| Super + C | VS Code |
| Super + Q | Close window |
| Super + F | Fullscreen |
| Super + 1-0 | Switch workspace |
| Super + I | Pick terminal logo |
| Super + O | Phone OTG toggle |
| Super + Z | Plover steno toggle |
| Super + F1/F2/F3 | Chrome profiles |
| Alt + M | Keyboard pointer overlay |
| Alt + i/k/j/l | Move cursor via keyboard |
| Alt + w/r | Left / right click |
| Alt + e/d/f/s | Scroll via keyboard |
| Alt + u/o | Switch workspace |
| Alt + Space | Cycle windows |
| Alt + minus/equal | Resize window |

## Scripts

| Script | Description |
|--------|-------------|
| `cursor-daemon.py` | Drives the keyboard-cursor system |
| `cursor-send.sh` | Sends cursor press/release events |
| `wl-kbptr-toggle.sh` | Toggles keyboard pointer overlay |
| `set-terminal-logo.sh` | Sets fastfetch image logo |
| `screenshot.sh` | Screenshot with rofi menu (grim + grimblast) |
| `plover-toggle.sh` | Toggles Plover stenography engine |
| `toggle-phone-otg.sh` | Toggles phone OTG connection |

## Syncing changes

After making config changes locally:

```bash
bash ~/my-dotfiles/sync.sh
```

> Wallpapers (`~/.config/ml4w/wallpapers/`) are excluded from the repo to keep it small.
