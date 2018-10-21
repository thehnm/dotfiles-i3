#!/bin/bash

mv arch_bootstrap.sh /

# Set localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

echo #####################################################################################################################

# Set up locale
sed -i 's/^#de_DE/de_DE/g' /etc/locale.gen
sed -i 's/^#en_US/en_US/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=de-latin1 >> /etc/vconsole.conf

echo #####################################################################################################################

# Set root password
passwd

echo #####################################################################################################################

# Set up user
read -p "Enter non-root user's name " name
useradd -m -g wheel $name
echo Set password for $name
passwd $name
chfn $name
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

echo #####################################################################################################################

# Install packages
curl https://raw.githubusercontent.com/thehnm/dotfiles-i3/master/arch_bootstrap/packages.txt >> packages.txt
xargs -a packages.txt pacman --color=auto --needed -S
mv packages.txt /

echo #####################################################################################################################

# Install yay aur helper
sudo -u $name git clone https://aur.archlinux.org/yay.git /home/$name/yay
cd /home/$name/yay
sudo -u $name makepkg -si

echo #####################################################################################################################

# Install aur packages
sudo -u $name yay -S i3lock-color polybar lightdm-webkit-theme-aether

echo #####################################################################################################################

# Systemd
systemctl enable NetworkManager
systemctl enable lightdm

echo #####################################################################################################################

# Install dotfiles
sudo -u $name git clone https://thehnm@github.com/thehnm/dotfiles-i3.git /home/$name/dotfiles-i3
cd /home/$name/dotfiles-i3/
sudo -H -u TARGET_USER bash -c 'bash install_dotfiles.sh'

echo #####################################################################################################################

# Exec i3 in xinitrc
echo exec i3 >> $HOME/.xinitrc

echo #####################################################################################################################

# Set up hostname
read -p "Enter desired hostname: " hostname
echo $hostname >> /etc/hostname
echo 127.0.0.1  localhost >> /etc/hosts
echo ::1	localhost >> /etc/hosts
echo 127.0.1.1	$hostname.localdomain	$hostname

echo #####################################################################################################################

# Install grub
read -p "Enter your disk label: dev/sdx? x: " label
read -p "Do you have UEFI enabled? " answer
while true
do
  case $answer in
   [yY]* ) pacman -S grub efibootmgr
           grub-install --target=x86_64-pc --bootloader-id=GRUB --efi-directory=/boot/efi/
           grub-mkconfig -o /boot/grub/grub.cfg
           break;;

   [nN]* ) pacman -S grub
           grub-install --target=i386-pc /dev/sd$label
           grub-mkconfig -o /boot/grub/grub.cfg
           break;;

   * )     echo "Dude, just enter Y or N, please."; break ;;
  esac
done

echo #####################################################################################################################

# Fix audio problem
sed -i 's/^ autospawn/; autospawn/g' /etc/pulse/client.conf

echo #####################################################################################################################

cd /home/$name
sudo -u $name git clone https://github.com/VundleVim/Vundle.vim.git /home/$name/.vim/bundle/Vundle.vim
sudo -u $name vim +PluginInstall +qall

echo #####################################################################################################################

rm /packages.txt
rm /arch_bootstrap.txt

echo -e Done. Reboot now!
