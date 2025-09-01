#!/bin/bash

# works best if you start with a plain install of arch no window/login manager just plain shell 

if [[ ! -f "isdj09dj20s029jd0983hj09de83hj4.dontdelete" ]]; then
  echo -e "cd into the setup directory\nexiting..."
  exit 1
fi

sudo rm -rf /etc/pacman.conf
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo cp pacman.conf /etc/pacman.conf

sudo pacman -Sy --noconfirm

sudo pacman -S --needed --noconfirm git base-devel networkmanager vim alacritty i3 i3-gaps rust ttf-jetbrains-mono-nerd ttf-jetbrains-mono fastfetch python-pip npm python neovim btop rofi bluez nwg-look thunar feh xclip mesa xf86-video-intel mesa-demos eog pavucontrol blueberry krita vlc vlc-plugin-ffmpeg maim polybar qbittorrent unzip zip wget ly qt5-declarative qt5-tools kdeclarative kirigami2 plasma-framework5 gnome-calculator 7zip xorg-xev xorg-xinput xorg-xinit xorg-server xorg-xauth openssh fzf xsettingsd xcolor reflector trash-cli vulkan-tools xf86-input-wacom xf86-video-intel git-filter-repo ranger lxappearance gtk-update-icon-cache gdk-pixbuf2 gnome-keyring libsecret unclutter

# kdenlive

git clone https://aur.archlinux.org/paru-git.git
cd paru-git
makepkg -si
cd ..
paru -S --noconfirm --needed brave-bin breeze-snow-cursor-theme sparrow-wallet crispy-doom-git picom-ftlabs-git tela-circle-icon-theme-manjaro jellyfin-media-player
#  tor-browser-bin

sudo timedatectl set-timezone America/Chicago
sudo gdk-pixbuf-query-loaders --update-cache

# ensure gnome-keyring autostarts for X sessions (only needed if using startx)
if ! grep -q "gnome-keyring-daemon" ~/.xinitrc 2>/dev/null; then
  echo 'eval $(gnome-keyring-daemon --start)' >> ~/.xinitrc
  echo 'export SSH_AUTH_SOCK' >> ~/.xinitrc
fi

# automatically create a "login" keyring with a blank password
mkdir -p ~/.local/share/keyrings
cat > ~/.local/share/keyrings/login.keyring <<'EOF'
[Keyring]
display-name=Login
ctime=$(date +%s)
mtime=$(date +%s)
lock-on-idle=false
EOF

pip install --break-system-packages simple-term-menu pyright pynvim inotify-simple

sudo systemctl enable ly
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable sshd

mkdir -p ~/Pictures/Screenshots

rm ~/.bashrc
cp .bashrc ~/
source ~/.bashrc

rm -rf ~/.config/i3
cp -rf i3/ ~/.config/ 

rm -rf ~/.config/ranger/
cp -rf ranger/ ~/.config/

rm -rf ~/.config/picom/
cp -rf picom ~/.config/

rm -rf ~/.config/alacritty
cp -rf alacritty/ ~/.config

chmod +x scripts/*
sudo cp scripts/* /bin

mkdir ~/scripts
cp scripts/* ~/Scripts/

sudo cp resolv.conf /etc/

rm -rf ~/.config/btop/
cp -rf btop/ ~/.config

rm -rf ~/.config/polybar/
cp -rf polybar/ ~/.config/

rm ~/.xprofile
cp .xprofile ~/

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
cp -rf ZorinGreen-Dark* ~/.themes/

mkdir ~/.icons/ 
cp -rf Tela ~/.icons/

set_gtk_theme.sh ZorinGreen-Dark

gsettings set org.gnome.desktop.interface gtk-theme "ZorinGreen-Dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface font-name "JetBrains Mono NL SemiBold"
gsettings set org.gnome.desktop.interface gtk-theme 'ZorinGreen-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Tela circle manjaro dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Breeze_Light'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
mkdir -p ~/.config/gtk-3.0
echo -e "[Settings]\ngtk-theme-name=ZorinGreen-Dark" > ~/.config/gtk-3.0/settings.ini
mkdir -p ~/.config/gtk-4.0
echo -e "[Settings]\ngtk-theme-name=ZorinGreen-Dark" > ~/.config/gtk-4.0/settings.ini
echo 'gtk-theme-name="ZorinGreen-Dark"' > ~/.gtkrc-2.0
echo 'export GTK_THEME=ZorinGreen-Dark' >> ~/.xprofile
echo -e "[Settings]\ngtk-icon-theme-name=Tela circle manjaro dark" > ~/.config/gtk-3.0/settings.ini
echo -e "[Settings]\ngtk-icon-theme-name=Tela circle manjaro dark" > ~/.config/gtk-4.0/settings.ini

sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo mkdir -p /boot/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

rm -rf ~/.config/rofi/
cp -rf rofi/ ~/.config/

cp -rf Wallpaper/ ~/

sudo rm /etc/ly/config.ini
sudo cp ly-config.ini /etc/ly/config.ini

sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee /etc/X11/xorg.conf.d/90-touchpad.conf > /dev/null <<EOF
Section "InputClass"
    Identifier "touchpad"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "TappingButtonMap" "lrm"  # 1/2/3 finger tap buttons (left, right, middle)
EndSection
EOF

read -p "do you want to copy extra files using ssh? (y/n): " answer
if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
  read -p "enter the username for the remote machine: " username
  read -p "enter the ip address of the remote machine: " ip
  read -p "enter the full path to the folder (do not use ~): " folder

  echo "this will copy the contents of $folder to your home directory. do you want to proceed? (y/n): "
  read proceed
  if [[ "$proceed" == "y" || "$proceed" == "yes" ]]; then
    scp -r "$username@$ip:$folder" ~/.config/
  else
    echo "skipping file copy."
  fi
else
  echo "skipping file copy."
fi

if sudo grep -q '^HandleLidSwitch=' /etc/systemd/logind.conf; then
  sudo sed -i 's/^#*HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
else
  echo 'HandleLidSwitch=ignore' | sudo tee -a /etc/systemd/logind.conf >/dev/null
fi

if sudo grep -q '^HandleLidSwitchDocked=' /etc/systemd/logind.conf; then
  sudo sed -i 's/^#*HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
else
  echo 'HandleLidSwitchDocked=ignore' | sudo tee -a /etc/systemd/logind.conf >/dev/null
fi


# ============================ #
echo "done! rebooting now..."
cp -rf i3/ ~/.config/ # just incase
reboot
