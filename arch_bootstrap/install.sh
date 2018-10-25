#!/bin/bash

###############################################################################

setlocale() {
  answer=$(dialog --title "Locale settings" --yesno "Do you want to edit the locale.gen file?" 5 45 3>&1 1>&2 2>&3 3>&1 || exit)
  case $? in
    0 ) clear && sudo vim /etc/locale.gen
        break;;
    1 ) break;;
  esac
}

settimezone() {
  # Select continent
  C=(1 "Africa" 2 "America" 3 "Antarctica" 4 "Arctic" 5 "Asia" 6 "Australia" 7 "Europe" 8 "Pacific")
  choice1=$(dialog --title "Set timezone" --menu "Chose one" 24 80 17 "${C[@]}" 3>&2 2>&1 1>&3)
  continent=${C[2*$choice1-1]}

  # Select city
  let i=0 # define counting variable
  W=() # define working array
  while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
  done < <( ls -1 /usr/share/zoneinfo/$continent )
  choice2=$(dialog --title "Set timezone" --menu "Chose one" 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3)
  clear
  if [ $? -eq 0 ]; then # Exit with OK
    city=${W[2*$choice2-1]}
    echo "/usr/share/zoneinfo/$continent/$city"
  fi

  # Set localtime
  ln -sf /usr/share/zoneinfo/$continent/$city /etc/localtime
  hwclock --systohc
}

###############################################################################

bold=$(tput bold)
normal=$(tput sgr0)
GREEN='\033[0;32m'
NC='\033[0m'

echodone() {
  echo -e " ${GREEN}[Done]${NC}"
}

setrootpasswd() {
  echo ${bold}Setting root password${normal}
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

install() {
  echo -n "Installing $1"
  pacman --noconfirm --needed -S "$1" &>/dev/null
  echodone
}

aurinstall() {
  echo "Installing $1 from AUR"
  sudo -u $name yay --noconfirm -S "$1"
  echodone
}

installyay() {
  echo ${bold}Install yay AUR helper${normal}
  pacman --noconfirm -S git &>/dev/null
  sudo -u $name git clone https://aur.archlinux.org/yay.git /home/$name/yay
  cd /home/$name/yay
  sudo -u $name makepkg --noconfirm -si
  echodone
}

installloop() {
  curl https://raw.githubusercontent.com/thehnm/dotfiles-i3/master/arch_bootstrap/packages.csv >> /tmp/packages.csv
  while true
  do
    read -p "Do you want i3bar or polybar? " bar
    case $bar in
      "i3bar" ) sed -i '/A,polybar/d' /tmp/packages.csv
                break;;

      "polybar" ) sed -i '/,i3blocks/d' /tmp/packages.csv
                  sed -i '/,i3status/d' /tmp/packages.csv
                  sed -i '/,dmenu/d' /tmp/packages.csv
                  break;;

      * ) echo "Dude, just enter i3bar or polybar, please.";;
    esac
  done

  read -p "Do you want to edit the list of packages to be installed? " edit
  while true
  do
    case $edit in
      [yY]* ) nano /tmp/packages.csv
              break;;

      [nN]* ) break;;

      * ) break ;;
    esac
  done

  echo -n "Installing archlinux-keyring"
  pacman --noconfirm -Sy archlinux-keyring &>/dev/null
  echodone

  INPUT=/tmp/packages.csv
  IFS=,
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  while read tag program
  do
    case $tag in
      "") install "$program" ;;
      "A") aurinstall "$program" ;;
    esac
  done < $INPUT
}

enableservices() {
  echo -n ${bold}Enable systemd services${normal}
  systemctl enable NetworkManager &>/dev/null
  systemctl enable lightdm &>/dev/null
  echodone
}

installdotfile() {
  echo ${bold}Install my i3 dotfile${normal}
  sudo -u $name git clone https://thehnm@github.com/thehnm/dotfiles-i3.git /home/$name/dotfiles-i3
  cd /home/$name/dotfiles-i3/
  case $bar in
    "i3bar" ) sudo -u $name sed -i '/polybar/d' /home/$name/dotfiles-i3/config.stow/.config/i3/config
              sudo -u $name sed -i '/rofi/d' /home/$name/dotfiles-i3/config.stow/.config/i3/config
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
  echo ${bold}Set up host${normal}
  read -p "Enter desired hostname: " hostname
  echo $hostname >> /etc/hostname
  echo 127.0.0.1        localhost >> /etc/hosts
  echo ::1	localhost >> /etc/hosts
  echo 127.0.1.1	$hostname.localdomain   $hostname >> /etc/hosts
  echodone
}

installgrub() {
  echo ${bold}Set up grub boot loader${normal}
  read -p "Enter the last character your disk label where Arch is installed (dev/sd_): " label
  while true
  do
    read -p "Do you have UEFI enabled? " answer
    case $answer in
      [yY]* ) echo -n "Installing grub"
              pacman --noconfirm -S grub efibootmgr
              grub-install --target=x86_64-pc --bootloader-id=GRUB --efi-directory=/boot/efi/
              grub-mkconfig -o /boot/grub/grub.cfg
              echodone
              break;;

      [nN]* ) echo -n "Installing grub"
              pacman --noconfirm -S grub
              grub-install --target=i386-pc /dev/sd$label
              grub-mkconfig -o /boot/grub/grub.cfg
              echodone
              break;;

      * ) echo "Dude, just enter Y or N, please.";;
    esac
  done
  echodone
}

##########################################################################################################################

echo -n "${bold}Move arch_bootstrap.sh to /tmp/${normal}"
mv arch_bootstrap.sh /tmp/
echodone

setlocaltime

setlocale

setrootpasswd

setupnewuser

installyay

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
cd /home/$name/
sudo -u $name git clone https://github.com/VundleVim/Vundle.vim.git /home/$name/.vim/bundle/Vundle.vim
echodone

echo -n ${bold}Remove packages.csv and arch_bootstrap.sh${normal}
rm /tmp/packages.csv
rm /tmp/arch_bootstrap.sh
echodone

echo ${bold}Done. Reboot now!${normal}
