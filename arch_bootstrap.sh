#!/bin/bash

GREEN='\033[0;32m'

# Install packages
pacman --color=auto --needed -S sed rofi firefox networkmanager nm-connection-editor lightdm lightdm-gtk-greeter-settings termite network-manager-applet xorg-server xorg-xinit dunst gnome-keyring compton stow openvpn pass ttf-dejavu ctags nitrogen libsecret udiskie alsa-utils openssh pulseaudio pavucontrol lxappearance mupdf libmpdclient dialog lightdm-webkit2-greeter zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting texlive-most git conky cmake make

# Install yay aur helper
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si

# Install aur packages
yay -S i3lock-color polybar lightdm-webkit-theme-aether

# Systemd
systemctl enable NetworkManager
echo -e systemctl enable NetworkManager ${GREEN}[OK]
systemctl enable lightdm
echo -e systemctl enable lightdm ${GREEN}[OK]

# Set root password
passwd
echo -e Password for root setted ${GREEN}[OK]

# Set up user
read -p "Enter non-root user's name " name
useradd -m -g wheel $name
echo Set password for $name
passwd $name
chfn $name
echo -e Password for $name setted ${GREEN}[OK]
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

# Install dotfiles
git clone https://thehnm@github.com/thehnm/dotfiles-i3.git $HOME/dotfiles-i3
cd $HOME/dotfiles-i3/
bash install_dotfiles.sh
echo -e Dotfiles installed ${GREEN}[OK]

# Exec i3 in xinitrc
echo exec i3 >> $HOME/.xinitrc

# Set localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo -e Localtime set ${GREEN}[OK]

# Set up locale
sed -i 's/^#de_DE./de_DE./g' /etc/locale.gen
sed -i 's/^#en_US./en_US./g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=de-latin1 >> /etc/vconsole.conf
echo -e Locale set ${GREEN}[OK]

# Set up hostname
read -p "Enter desired hostname: " hostname
echo $hostname >> /etc/hostname

echo 127.0.0.1  localhost >> /etc/hosts
echo ::1	localhost >> /etc/hosts
echo 127.0.1.1	$hostname.localdomain	$hostname

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
echo -e Grub successfully installed ${GREEN}[OK]

# Fix audio problem
sed -i 's/^ autospawn./; autospawn./g' /etc/pulse/client.conf

cd /home/$name
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo -e Done. Reboot now!
