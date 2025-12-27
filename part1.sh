#!/usr/bin/env bash
set -euo pipefail

cd etc

find . -type f | while IFS= read -r path; do
  rel="${path#./}"
  target="/mnt/etc/$rel"

  mkdir -p "$(dirname "$target")"

  echo "copying $PWD/$rel to $target"
  cp "$PWD/$rel" "$target"
done

cd ..

echo "what keymap are you using? type 'us' for a standard qwerty keyboard"
read -p "> " keymap
echo "KEYMAP=$keymap" > /mnt/etc/vconsole.conf

pacstrap -K /mnt base-devel linux linux-firmware neovim git
genfstab -U /mnt >> /mnt/etc/fstab

cp part2.sh /mnt

echo "now, run arch-chroot /mnt"
echo "then, /part2.sh"
