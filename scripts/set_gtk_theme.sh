
#!/bin/bash

theme="$1"
icon_theme="Tela"
cursor_theme="Breeze_Light"
font_name="JetBrains Mono NL SemiBold"
color_scheme="prefer-dark"

# Apply theme settings via gsettings
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
gsettings set org.gnome.desktop.interface font-name "$font_name"
gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"

# Write GTK config files
mkdir -p ~/.config/gtk-3.0
echo -e "[Settings]\ngtk-theme-name=$theme" > ~/.config/gtk-3.0/settings.ini

mkdir -p ~/.config/gtk-4.0
echo -e "[Settings]\ngtk-theme-name=$theme" > ~/.config/gtk-4.0/settings.ini

echo "gtk-theme-name=\"$theme\"" > ~/.gtkrc-2.0

# Update GTK_THEME in ~/.xprofile
sed -i '/^export GTK_THEME=/d' ~/.xprofile
echo "export GTK_THEME=$theme" >> ~/.xprofile

# Restart xsettings daemons to force theme reload
if pgrep xfsettingsd >/dev/null; then
    pkill xfsettingsd
    nohup xfsettingsd >/dev/null 2>&1 &
elif pgrep xsettingsd >/dev/null; then
    pkill xsettingsd
    nohup xsettingsd >/dev/null 2>&1 &
fi

# Restart GNOME settings daemon's xsettings (if installed)
if [ -x /usr/lib/gsd-xsettings ]; then
    pkill -f gsd-xsettings
    nohup /usr/lib/gsd-xsettings >/dev/null 2>&1 &
fi

# Export GTK_THEME for current session to force immediate effect
export GTK_THEME="$theme"

echo "Theme set to '$theme' and GTK theme reloaded."
