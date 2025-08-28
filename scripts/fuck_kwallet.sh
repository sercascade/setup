#!/bin/bash

# Kill KWallet Daemon if running
pkill kwalletd5 2>/dev/null
pkill gnome-keyring-daemon 2>/dev/null

# Disable auto-start of KWallet
KWALLET_AUTOSTART="$HOME/.config/autostart/kwalletd5.desktop"
if [ -f "$KWALLET_AUTOSTART" ]; then
    rm -f "$KWALLET_AUTOSTART"
fi

# Disable KWallet in KDE config
KDE_WALLET_CONF="$HOME/.config/kwalletrc"
if [ -f "$KDE_WALLET_CONF" ]; then
    sed -i 's/^Enabled=true/Enabled=false/' "$KDE_WALLET_CONF"
else
    cat > "$KDE_WALLET_CONF" <<EOF
[Wallet]
Enabled=false
EOF
fi

# Also modify kdeglobals in case
KDE_GLOBALS="$HOME/.config/kdeglobals"
if ! grep -q "\[Wallet\]" "$KDE_GLOBALS" 2>/dev/null; then
    echo -e "\n[Wallet]\nEnabled=false" >> "$KDE_GLOBALS"
fi

# Make sure GNOME Keyring doesn't start either (some apps trigger it)
mkdir -p ~/.config/autostart
echo "[Desktop Entry]
Type=Application
Name=Disable GNOME Keyring
Exec=true
Hidden=true" > ~/.config/autostart/gnome-keyring-pkcs11.desktop
cp ~/.config/autostart/gnome-keyring-pkcs11.desktop ~/.config/autostart/gnome-keyring-secrets.desktop
cp ~/.config/autostart/gnome-keyring-pkcs11.desktop ~/.config/autostart/gnome-keyring-ssh.desktop

echo "✅ KDE Wallet (KWallet) and GNOME Keyring disabled at startup."
