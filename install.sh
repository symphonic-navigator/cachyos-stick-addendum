#! /bin/bash

# --- script setup ---
set -euo pipefail

# --- helpers ---
have() { command -v "$1" >/dev/null 2>&1; }

# --- safeguard ---
if [[ $EUID -eq 0 ]]; then
  echo "❌ do not run this script as root or sudo"
  exit 1
fi

mkdir -p "$HOME/repos"

# --- installation of basic prerequisites ---
echo "📦 installing base prerequisites..."
sudo pacman -S --needed --noconfirm git github-cli neovim sddm chezmoi

# yay: try pacman first (CachyOS may provide it); otherwise bootstrap
if ! have yay; then
  if sudo pacman -S --needed --noconfirm yay; then
    true
  else
    echo "🧰 bootstrapping yay..."
    sudo pacman -S --needed --noconfirm base-devel
    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
  fi
fi

echo "🎨 installing chili-sddm-theme..."
yay -S --needed --noconfirm chili-sddm-theme

# --- sddm setup ---
echo "🖥️ enabling SDDM..."
sudo systemctl enable sddm

# --- activate chili-sddm-theme ---
echo "⚙️ configuring SDDM theme..."
SDDM_CONF="/etc/sddm.conf.d/10-theme.conf"

if ! grep -q "^Current=chili" "$SDDM_CONF" 2>/dev/null; then
  echo "⚙️ Activating Chili theme in SDDM..."
  sudo mkdir -p "$(dirname "$SDDM_CONF")"

  sudo tee -a "$SDDM_CONF" >/dev/null <<EOF
    
[Theme]
Current=chili

[General]
CursorTheme=breeze_cursors
EOF
fi

# --- chezmoi init (no apply here on purpose) ---
echo "🥐 chezmoi init..."
if [[ ! -d "$HOME/.local/share/chezmoi" ]]; then
  chezmoi init "https://github.com/symphonic-navigator/chezmoi-repo-end4"
  chezmoi git remote set-url origin "git@github.com:symphonic-navigator/cachyos-stick-addendum.git"
fi

# --- installation of end-4 ---
echo "🌿 installing end-4 dots..."
if [[ -d "$HOME/repos/dots-hyprland" ]]; then
  rm -rf "$HOME/repos/dots-hyprland" || true
fi
git clone https://github.com/end-4/dots-hyprland.git "$HOME/repos/dots-hyprland"
cd $HOME/repos/dots-hyprland
bash -c "$HOME/repos/dots-hyprland/setup install"
