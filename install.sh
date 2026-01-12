#! /bin/bash

# --- script setup ---
set -euo pipefail

# --- installation of basic prerequisites ---
sudo pacman -S --needed --noconfirm git github-cli sddm
yay -S --needed --noconfirm chili-sddm-theme

# --- sddm setup ---
sudo systemctl enable sddm

# --- activate chili-sddm-theme ---
SDDM_CONF="/etc/sddm.conf"

if ! grep -q "^Current=chili" "$SDDM_CONF" 2>/dev/null; then
  echo "⚙️ Activating Chili theme in SDDM..."
  sudo mkdir -p "$(dirname "$SDDM_CONF")"

  # Bestehende [Theme]-Section erweitern oder neu anlegen
  sudo tee -a "$SDDM_CONF" >/dev/null <<EOF
    
[Theme]
Current=chili
CursorTheme=breeze_cursors  # oder was du magst – chili passt gut zu breeze
EOF
fi

# --- installation of end-4 ---
git clone https://github.com/end-4/dots-hyprland.git $HOME/repos/dots-hyprland
cd $HOME/repos/dots-hyprland
#bash -c "$HOME/repos/dots-hyprland/setup install"
