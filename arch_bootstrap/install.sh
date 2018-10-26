#!/bin/bash

[ -z ${dotfilesrepo+x} ] && dotfilesrepo="https://github.com/thehnm/dotfiles-i3.git"

###############################################################################

initialcheck() { pacman -S --noconfirm --needed dialog || { echo "Are you sure you're running this as the root user? Are you sure you're using an Arch-based distro? ;-) Are you sure you have an internet connection?"; exit; } ;}

welcomemsg() { \
  dialog --title "Welcome!" --msgbox "Welcome to thehnm's Arch Linux Installation Script!\\n\\nThis script will automatically install a fully-featured i3wm Arch Linux desktop, which I use as my main machine.\\n\\n-thehnm" 10 60
}

preinstallmsg() { \
  dialog --title "Start installing the script!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "It will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit; }
}

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
  if [ "$?" = "0" ]; then # Exit with OK
    city=${W[2*$choice2-1]}
    echo "/usr/share/zoneinfo/$continent/$city"
  fi

  # Set localtime
  ln -sf /usr/share/zoneinfo/$continent/$city /etc/localtime
  hwclock --systohc
}

getuserandpass() {
  # Prompts user for new username an password.
  # Checks if username is valid and confirms passwd.
  name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit
  namere="^[a-z_][a-z0-9_-]*$"
  while ! [[ "${name}" =~ ${namere} ]]; do
  	name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
  done
  pass1=$(dialog --no-cancel --insecure --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
  pass2=$(dialog --no-cancel --insecure --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
  while ! [[ ${pass1} == ${pass2} ]]; do
 	unset pass2
	pass1=$(dialog --no-cancel --insecure --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --insecure --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
  done ;}

usercheck() { \
  ! (id -u $name &>/dev/null) ||
  dialog --colors --title "WARNING!" --yes-label "CONTINUE" --no-label "No wait..." --yesno "The user \`$name\` already exists on this system. This script can install for a user already existing, but it will \\Zboverwrite\\Zn any conflicting settings/dotfiles on the user account.\\n\\nThis script will \\Zbnot\\Zn overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\\n\\nNote also that this script will change $name's password to the one you just gave." 14 70
}

adduserandpass() { \
  # Adds user `$name` with password $pass1.
  dialog --infobox "Adding user \"$name\"..." 4 50
  useradd -m -g wheel -s /bin/bash "$name" &>/dev/null ||
  usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
  echo "$name:$pass1" | chpasswd
  unset pass1 pass2 ;}

refreshkeys() { \
  dialog --infobox "Refreshing Arch Keyring..." 4 40
  pacman --noconfirm -Sy archlinux-keyring &>/dev/null
}

installyay() {
  dialog --infobox "Installing yay, an AUR helper..." 8 50
  pacman --noconfirm -S git &>/dev/null
  sudo -u $name git clone https://aur.archlinux.org/yay.git /home/$name/yay &>/dev/null
  cd /home/$name/yay
  sudo -u $name makepkg --noconfirm -si &>/dev/null
}

pacmaninstall() {
  dialog --title "Installation" --infobox "Installing \`$1\` ($n of $total)." 5 70
  pacman --noconfirm --needed -S "$1" &>/dev/null
}

aurinstall() {
  dialog --title "Installation" --infobox "Installing \`$1\` ($n of $total) from the AUR." 5 70
  sudo -u $name yay --noconfirm -S "$1" &>/dev/null
}

choosebar() {
  bar=$(dialog --title "Select bar" --radiolist "Do you want i3bar or polybar?" 10 80 17 1 i3bar on 2 polybar off 3>&2 2>&1 1>&3)
  while [ "$?" = "1" ];
  do
    bar=$(dialog --title "Select bar" --radiolist "You must choose one!" 10 80 17 1 i3bar on 2 polybar off 3>&2 2>&1 1>&3)
  done
  case $bar in
      1 ) sed -i '/A,polybar/d' $1
          break;;
      2 ) sed -i '/,i3blocks/d' $1
          sed -i '/,i3status/d' $1
          break;;
  esac
}

chooselauncher() {
  launcher=$(dialog --title "Select program launcher" --radiolist "Do you want dmenu or rofi?" 10 80 17 1 dmenu on 2 rofi off 3>&2 2>&1 1>&3)
  while [ "$?" = "1" ];
  do
    launcher=$(dialog --title "Select program launcher" --radiolist "You must choose one!" 10 80 17 1 dmenu on 2 rofi off 3>&2 2>&1 1>&3)
  done
  case $launcher in
    1 ) sed -i '/,rofi/d' $1
        break;;
    2 ) sed -i '/,dmenu/d' $1
        break;;
  esac
}

editpackages() {
  edit=$(dialog --yesno "Do you want to edit the packages file?" 10 80 3>&2 2>&1 1>&3)
}

installloop() {
  curl https://raw.githubusercontent.com/thehnm/dotfiles-i3/master/arch_bootstrap/packages.csv >> /tmp/packages.csv
  choosebar "/tmp/packages.csv"
  chooselauncher "/tmp/packages.csv"
  total=$(wc -l < /tmp/packages.csv)
  aurinstalled=$(pacman -Qm | awk '{print $1}')
  while IFS=, read -r tag program; do
   n=$((n+1))
   case "$tag" in
    "") pacmaninstall "$program" ;;
    "A") aurinstall "$program" ;;
   esac
  done < /tmp/packages.csv ;
}

putgitrepo() { # Downlods a gitrepo $1 and places the files in $2 only overwriting conflicts
  dialog --infobox "Downloading and installing config files..." 4 60
  dir=$(mktemp -d)
  chown -R "$name":wheel "$dir"
  sudo -u "$name" git clone "$1" "$dir"/"$3" &>/dev/null &&
  sudo -u "$name" mkdir -p "$2" &&
  sudo -u "$name" cp -rT "$dir"/"$3" "$2"
}

installdotfiles() {
  dialog --infobox "Installing my dotfiles..." 4 60
  cd /home/$name/dotfiles-i3/
  bash "install_dotfiles.sh"
}

serviceinit() {
  for service in "$@"; do
    dialog --infobox "Enabling \"$service\"..." 4 40
    systemctl enable "$service"
    systemctl start "$service"
  done ;}

setxinitrc() {
  dialog --infobox "Setting xinitrc..." 4 40
  echo exec i3 >> $HOME/.xinitrc
}

newperms() { # Set special sudoers settings for install (or after).
  dialog --infobox "Getting rid of that retarded error beep sound..." 10 50
  sed -i "/#SCRIPT/d" /etc/sudoers
  echo -e "$@ #SCRIPT" >> /etc/sudoers ;}

systembeepoff() {
  dialog --infobox "Getting rid of that retarded error beep sound..." 10 50
  rmmod pcspkr
  echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf ;}

resetpulse() {
  dialog --infobox "Reseting Pulseaudio..." 4 50
  killall pulseaudio
  sudo -n "$name" pulseaudio --start ;}

setuphost() {
  host=$(dialog --inputbox "Enter the name for your host" 10 60 3>&1 1>&2 2>&3 3>&1) || exit
  namere="^[a-z_][a-z0-9_-]*$"
  while ! [[ "${host}" =~ ${namere} ]]; do
  	name=$(dialog --no-cancel --inputbox "Hostname not valid. Give a hostname beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
  done

  dialog --infobox "Setting hostname..." 4 50
  echo $host>> /etc/hostname
  echo 127.0.0.1        localhost >> /etc/hosts
  echo ::1	localhost >> /etc/hosts
  echo 127.0.1.1	$host.localdomain   $host >> /etc/hosts
}

installgrub() {
  choice=$(dialog --yesno "Do you install this on a UEFI machine?" 10 80 3>&2 2>&1 1>&3)
  case $? in
      0 ) dialog --infobox "Installing grub for UEFI..." 4 50
          pacman --noconfirm -S grub efibootmgr &>/dev/null
          grub-install --target=x86_64-pc --bootloader-id=GRUB --efi-directory=/boot/efi/ &>/dev/null
          grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null
          break;;
      1 ) label=$(dialog --inputbox "Enter the disk where your install Arch Linux e.g. /dev/sda" 10 60 3>&1 1>&2 2>&3 3>&1) || exit
          pacman --noconfirm -S grub
          grub-install --target=i386-pc $label
          grub-mkconfig -o /boot/grub/grub.cfg
          break;;
  esac
}

finish() {
  dialog --title "Welcome" --msgbox "The installation is done! You can reboot your system now." 10 80
}

##########################################################################################################################

mv install.sh /tmp/install.sh

# Check if user is root on Arch distro. Install dialog.
initialcheck

# Welcome user.
welcomemsg

setlocale

settimezone

# Get and verify username and password.
getuserandpass

# Give warning if user already exists.
usercheck || { clear; exit; }

setuphost

# Last chance for user to back out before install.
preinstallmsg || { clear; exit; }

adduserandpass

refreshkeys

newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

installyay

installloop

# Install the dotfiles in the user's home directory
putgitrepo "$dotfilesrepo" "/home/$name" "dotfiles-i3"

installdotfiles

putgitrepo "https://github.com/VundleVim/Vundle.vim.git" "home/$name/.vim/bundle/" "Vundle.vim"

# Pulseaudio, if/when initially installed, often needs a restart to work immediately.
[[ -f /usr/bin/pulseaudio ]] && resetpulse

serviceinit NetworkManager

systembeepoff

newperms "%wheel ALL=(ALL) ALL\\n%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay"

sed -i "s/^#Color/Color/g" /etc/pacman.conf

# Fix audio problem
sed -i 's/^ autospawn/; autospawn/g' /etc/pulse/client.conf

installgrub

finish || { clear; exit; }
