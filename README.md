# My Dotfiles

Personal Hyprland customizations on top of ML4W dotfiles.

## Keybinds (custom.conf)
| Shortcut | Action |
|----------|--------|
| Super + I | Pick terminal logo image |
| Super + C | VS Code |
| Super + W | Browser (Chrome) |
| Super + O | Phone OTG toggle |
| Super + Z | Plover toggle |
| Super + P | Screenshot |
| Super + F1/F2/F3 | Chrome profiles |
| Alt + M | Keyboard pointer overlay |
| Alt + i/k/j/l | Move cursor via keyboard |
| Alt + w/r | Left / right click via keyboard |
| Alt + e/d/f/s | Scroll via keyboard |
| Alt + u/o | Switch workspace |
| Alt + Space | Cycle windows |
| Alt + minus/equal | Resize window |

## Scripts
| Script | Description |
|--------|-------------|
| `cursor-daemon.py` | Drives the keyboard-cursor system |
| `cursor-send.sh` | Sends cursor press/release commands |
| `wl-kbptr-toggle.sh` | Toggles keyboard pointer overlay (Alt+M) |
| `set-terminal-logo.sh` | Picks an image and sets it as fastfetch logo (Super+I) |

## Config files
| File | Description |
|------|-------------|
| `fastfetch/config.jsonc` | Fastfetch layout with image logo |
| `zshrc/20-customization` | Zsh plugins (oh-my-zsh) |
| `ml4w/settings/browser.sh` | Default browser |
| `rofi/config.rasi` | Rofi launcher config |

## Apply
```bash
cp -r .config ~/
```

