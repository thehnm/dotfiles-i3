#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)
GREEN='\033[0;32m'
NC='\033[0m'

##########################################################################################################################

echodone() {
  echo -e " ${GREEN}[Done]${NC}"
}

setlocaltime() {
  echo -n "${bold}Setting localtime to Berlin${normal}"
  ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
  hwclock --systohc
  echodone
}

setlocale() {
  echo -n ${bold}Setting locale${normal}
  sed -i 's/^#de_DE/de_DE/g' /etc/locale.gen
  sed -i 's/^#en_US/en_US/g' /etc/locale.gen
  locale-gen
  echo LANG=en_US.UTF-8 >> /etc/locale.conf
  echo LANGUAGE=en_US.UTF-8 >> /etc/locale.conf
  echo LC_ALL=de_DE.UTF-8 >> /etc/locale.conf
  echo KEYMAP=de-latin1 >> /etc/vconsole.conf
  echodone
}

setrootpasswd() {
  echo -n ${bold}Setting root password${normal}
  passwd
  echodone
}

setupnewuser() {
  echo ${bold}Create new user${normal}
  read -p "Enter non-root user's name: " name
  useradd -m -g wheel $name
  echo Set password for $name
  passwd $name
  chfn $name
  sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
}

installyay() {
  echo ${bold}Install yay AUR helper${normal}
  sudo -u $name git clone https://aur.archlinux.org/yay.git /home/$name/yay
  cd /home/$name/yay
  sudo -u $name makepkg -si
  echodone
}

install() {
  echo -n "Installing $1"
  pacman --needed -S "$1" &>/dev/null
  echodone
}

aurinstall() {
  echo -n "Installing $1 from AUR"
  sudo -u $name yay -S "$1" &>/dev/null
  echodone
}

installloop() {
  curl https://raw.githubusercontent.com/thehnm/dotfiles-i3/master/arch_bootstrap/packages.csv >> /tmp/packages.csv
  while true
  do
    read -p "Do you want i3bar or polybar?" bar
    case $bar in
      "i3" ) sed -i '/A,Polybar/d' /tmp/packages.csv
             break;;

      "polybar" ) sed -i '/,i3blocks/d' /tmp/packages.csv
                  sed -i '/,i3status/d' /tmp/packages.csv
                  break;;

      * )     echo "Dude, just enter i3bar or polybar, please.";;
    esac
  done

  read -p "Do you want to edit the list of packages to be installed? " edit
  while true
  do
    case $edit in
      [yY]* ) nano /tmp/packages.txt
              break;;

      [nN]* ) break;;

      * ) break ;;
    esac
  done

  FILE=/tmp/data.csv
  IFS=,
  [ ! -f $FILE ] && { echo "$FILE file not found"; exit 99; }
  while read tag program
  do
    case $tag in
      "") install "$program" ;;
      "G") aurinstall "$program" ;;
    esac
  done < $INPUT
}

enableservices() {
  echo -n ${bold}Enable systemd services${normal}
  systemctl enable NetworkManager
  systemctl enable lightdm
  echodone
}

installdotfile() {
  echo -n ${bold}Install my i3 dotfile${normal}
  sudo -u $name git clone https://thehnm@github.com/thehnm/dotfiles-i3.git /home/$name/dotfiles-i3
  cd /home/$name/dotfiles-i3/
  case $bar in
    "i3" ) sudo -u $name sed -i '/polybar/d' /home/$name/dotfiles-i3/config.stow/.config/i3/config
      sudo -u $name sed -i 's/^#1//g' /home/$name/dotfiles-i3/config.stow/.config/i3/config
      break;;
    "polybar" ) sudo -u $name sed -i '/,i3blocks/d' /tmp/packages.csv
      sudo -u $name sed -i '/,i3status/d' /tmp/packages.csv
      break;;
  esac
  sudo -H -u $name bash -c 'bash install_dotfiles.sh'
  echodone
}

setxinitrc() {
  echo -n ${bold}Set xinitrc${normal}
  echo exec i3 >> $HOME/.xinitrc
  echodone
}


setuphost() {
  echo -n ${bold}Set up host${normal}
  read -p "Enter desired hostname: " hostname
  echo $hostname >> /etc/hostname
  echo 127.0.0.1        localhost >> /etc/hosts
  echo ::1	localhost >> /etc/hosts
  echo 127.0.1.1	$hostname.localdomain   $hostname >> /etc/hosts
  echodone
}

installgrub() {
  echo -n ${bold}Set up grub boot loader${normal}
  read -p "Enter the last character your disk label where Arch is installed (dev/sd_): " label
  while true
  do
    read -p "Do you have UEFI enabled? " answer
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
  echodone
}

##########################################################################################################################

echo -n "${bold}Move $1 to /tmp/${normal}"
mv $1 /tmp/
echodone

setlocaltime

setlocale

setrootpasswd

setupnewuser

installloop

enableservices

installdotfile

setxinitrc

setuphost

installgrub

# Fix audio problem
echo -n ${bold}Fix audio problem${normal}
sed -i 's/^ autospawn/; autospawn/g' /etc/pulse/client.conf
echodone

# Install vundle
echo -n ${bold}Install vundle${normal}
cd /home/$name
sudo -u $name git clone https://github.com/VundleVim/Vundle.vim.git /home/$name/.vim/bundle/Vundle.vim
echodone

echo -n ${bold}Remove packages.txt and arch_bootstrap.sh${normal}
rm /tmp/packages.txt
rm /tmp/arch_bootstrap.sh
echodone

echo ${bold}Done. Reboot now!${normal}
