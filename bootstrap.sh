#! /bin/bash

{
  # --- script setup ---
  set -euo pipefail

  # --- bootstrapping ---
  installer_dir="$HOME/repos/cachyos-stick-addendum"

  rm -rf "$installer_dir" || true
  mkdir -p "$installer_dir"
  git clone https://github.com/symphonic-navigator/cachyos-stick-addendum.git "$installer_dir"

  # --- launch ---
  bash -c "$installer_dir/install.sh"

  # --- clean exit ---
  exit 0
}
