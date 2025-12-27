echo "what is your region?"
ls /usr/share/zoneinfo
read -p "> " region

if [ -f "/usr/share/zoneinfo/$region" ]; then
    ln -sf "/usr/share/zoneinfo/$region" /etc/localtime
elif [ -d "/usr/share/zoneinfo/$region" ]; then
    echo "what is your time zone?"
    ls "/usr/share/zoneinfo/$region"
    read -p "> " zone
    if [ -n "$zone" ] && [ -f "/usr/share/zoneinfo/$region/$zone" ]; then
        ln -sf "/usr/share/zoneinfo/$region/$zone" /etc/localtime
    else
        echo "invalid zone: $zone"
        exit 1
    fi
else
    echo "invalid region: $region"
    exit 1
fi

hwclock --systohc

locale-gen
echo "you're going into locale.gen. please uncomment whichever UTF-8 locales you will be using"
sleep 3
nvim /etc/locale.gen
echo "type whichever your primary language zone is (e.g. en_US.UTF-8)"
read -p "> " lang
echo "LANG=$lang" > /etc/locale.conf

echo "now, for your hostname"
read -p "> " hostname
echo "$hostname" > /etc/hostname

sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
echo "enter root password"
passwd

echo "finally, what do you want your username to be?"
read -p "> " username
useradd "$username"
usermod -G wheel "$username"
mkdir "/home/$username"
chown "$username" "/home/$username"
echo "and now the password"
passwd "$username"

runuser -u "$username" -- bash <<'EOF'
  cd ~

  rustup default stable

  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ..

  git clone https://github.com/Omay238/owomay-dotfiles
  cd owomay-dotfiles
  ./update.sh
EOF

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P

rm /part2.sh
