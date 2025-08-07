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
