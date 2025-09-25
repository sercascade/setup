#!/bin/bash

# referenced by install.sh

read -p "nuke all gtk config? y/n " confirm
if [ "$confirm" = "y" ]; then
    rm -f ~/.gtkrc-2.0
    rm -rf ~/.config/gtk-3.0
    rm -rf ~/.config/gtk-4.0
fi

gtk_theme="ZorinOrange-Dark"
icon_theme="Tela-circle-ubuntu-dark"
cursor="Breeze_Snow" # package uses Breeze_Snow not "Breeze Light"
font="JetBrains Mono NL SemiBold 10"

# install themes
paru -S --noconfirm \
    breeze-snow-cursor-theme \
    tela-circle-icon-theme-ubuntu \
    zorin-desktop-themes

# ensure dirs exist
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

# GTK 2
cat > ~/.gtkrc-2.0 <<EOF
gtk-theme-name="$gtk_theme"
gtk-icon-theme-name="$icon_theme"
gtk-font-name="$font"
gtk-cursor-theme-name="$cursor"
EOF

# GTK 3
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=$gtk_theme
gtk-icon-theme-name=$icon_theme
gtk-font-name=$font
gtk-cursor-theme-name=$cursor
gtk-application-prefer-dark-theme=1
EOF

# GTK 4
cat > ~/.config/gtk-4.0/settings.ini <<EOF
[Settings]
gtk-theme-name=$gtk_theme
gtk-icon-theme-name=$icon_theme
gtk-font-name=$font
gtk-cursor-theme-name=$cursor
gtk-application-prefer-dark-theme=1
EOF

# export for some apps that respect env
grep -qxF "export GTK_THEME=\"$gtk_theme\"" ~/.xprofile || \
    echo "export GTK_THEME=\"$gtk_theme\"" >> ~/.xprofile

