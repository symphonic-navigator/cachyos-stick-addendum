#! /bin/bash

# --- script setup ---
set -euo pipefail

# --- safeguard ---
if [[ $EUID -eq 0 ]]; then
  echo "❌ do not run this script as root or sudo"
  exit 1
fi

# --- installation of basic prerequisites ---
sudo pacman -S --needed --noconfirm yay git github-cli sddm chezmoi
yay -S --needed --noconfirm chili-sddm-theme

# --- sddm setup ---
sudo systemctl enable sddm

# --- activate chili-sddm-theme ---
SDDM_CONF="/etc/sddm.conf"

if ! grep -q "^Current=chili" "$SDDM_CONF" 2>/dev/null; then
  echo "⚙️ Activating Chili theme in SDDM..."
  sudo mkdir -p "$(dirname "$SDDM_CONF")"

  sudo tee -a "$SDDM_CONF" >/dev/null <<EOF
    
[Theme]
Current=chili
CursorTheme=breeze_cursors  # oder was du magst – chili passt gut zu breeze
EOF
fi

# --- chezmoi init ---
chezmoi init "https://github.com/symphonic-navigator/chezmoi-repo-end4"

# --- installation of end-4 ---
if [[ -d "$HOME/repos/dots-hyprland" ]]; then
  rm -rf "$HOME/repos/dots-hyprland" || true
fi
git clone https://github.com/end-4/dots-hyprland.git "$HOME/repos/dots-hyprland"
cd $HOME/repos/dots-hyprland
bash -c "$HOME/repos/dots-hyprland/setup install"
