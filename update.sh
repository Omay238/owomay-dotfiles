#!/usr/bin/env bash
set -euo pipefail

cd dotfiles

find . -type f | while IFS= read -r path; do
  rel="${path#./}"
  target="$HOME/$rel"

  mkdir -p "$(dirname "$target")"

  echo "symlinking $PWD/$rel to $target"
  ln -sf "$PWD/$rel" "$target"
done
