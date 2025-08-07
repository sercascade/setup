#!/bin/bash

if [[ ! -f "isdj09dj20s029jd0983hj09de83hj4.dontdelete" ]]; then
  echo -e "cd into the setup directory\nexiting..."
  exit 1
fi

sudo rm -rf /etc/pacman.conf
sudo cp pacman.conf /etc/pacman.conf

sudo pacman -Sy --noconfirm

sudo pacman -S --noconfirm git base-devel networkmanager vim alacritty i3 i3-gaps rust ttf-jetbrains-mono-nerd ttf-jetbrains-mono fastfetch python-pip npm python neovim fastfetch btop rofi bluez nwg-look thunar feh xclip picom mesa xf86-video-intel mesa-demos eog picom pavucontrol blueberry xf86-input-wacom krita vlc vlc-plugin-ffmpeg xorg-xinput maim polybar qbittorrent unzip zip wget sddm qt5-declarative qt5-tools kdeclarative kirigami2 plasma-framework5

git clone https://aur.archlinux.org/paru-git.git
cd paru-git
makepkg -si
cd ..
paru -S --noconfirm --needed brave-bin breeze-snow-cursor-theme sparrow-wallet tor-browser-bin

sudo timedatectl set-timezone America/Chicago

pip install --break-system-packages simple-term-menu pyright pynvim inotify-simple

sudo systemctl enable sddm
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

rm ~/.bashrc
cp .bashrc ~/
source ~/.bashrc

rm -rf ~/.config/BraveSoftware
cp -rf BraveSoftware ~/.config

rm -rf ~/.config/i3
cp -rf i3/ ~/.config/ 

rm -rf ~/.config/picom/
cp -rf picom ~/.config/

rm -rf ~/.config/alacritty
cp -rf alacritty/ ~/.config

chmod +x scripts/*
sudo cp scripts/* /bin

rm -rf ~/.config/btop/
cp -rf btop/ ~/.config

rm -rf ~/.config/polybar/
cp -rf polybar/ ~/.config/

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.config/nvim/.git

git clone https://github.com/NvChad/starter ~/.config/nvim
rm -rf ~/.config/nvim/lua/chadrc.lua
cp chadrc.lua ~/.config/nvim/lua/

xdg-mime default eog.desktop image/*

for type in image/jpeg image/png image/gif image/bmp image/webp image/tiff; do
  xdg-mime default org.gnome.eog.desktop $type
done

mkdir ~/.themes/
cp -rf colloid* ~/.themes/
gsettings set org.gnome.desktop.interface gtk-theme "colloid"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Semibold 11"

mkdir ~/.icons/ 
cp -rf Numix ~/.icons/

sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo mkdir -p /boot/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

rm -rf ~/.config/rofi/
cp -rf rofi/ ~/.config/

cp -rf Wallpaper/ ~/

sudo rm -rf /usr/share/sddm/themes/sddm-sugar-candy-master/
sudo cp -rf sddm-sugar-candy-master/ /usr/share/sddm/themes/

sudo rm -rf /etc/sddm.conf
sudo cp sddm.conf /etc/

echo "done! rebooting now..."
reboot
