#! /bin/bash

# --- script setup ---
set -euo pipefail

installer_dir="$HOME/repos/cachyos-stick-addendum"

mkdir -p "$installer_dir"

git clone https://github.com/symphonic-navigator/cachyos-stick-addendum.git "$installer_dir"

bash -c "$installer_dir/install.sh"
