#!/usr/bin/env bash
set -euo pipefail

paru -Syu --noconfirm --skipreview --norebuild --noredownload $(cat packages.txt)

hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprscrolling

. other.txt

./update.sh
