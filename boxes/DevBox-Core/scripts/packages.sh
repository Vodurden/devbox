#!/bin/bash

# Fonts
cat <<EOF >> /etc/pacman.conf

[infinality-bundle]
Server = http://bohoomil.com/repo/\$arch

[infinality-bundle-fonts]
Server = http://bohoomil.com/repo/fonts
EOF

pacman-key -r 962DDE58
pacman-key --lsign-key 962DDE58
pacman -Syy

# Fontconfig and Freetype2 will be replaced by their infinality equivalents
yes | pacman -S cairo-infinality-ultimate
yes | pacman -S fontconfig-infinality-ultimate
yes | pacman -S freetype2-infinality-ultimate
yes | pacman -S ibfonts-meta-base

# X Core
pacman --noconfirm -S \
       xorg-server \
       xorg-xinit \
       xorg-xrdb

# GUI Tools
pacman --noconfirm -S \
       rxvt-unicode \
       xmonad \
       xmonad-contrib

pacman --noconfirm -S \
       firefox

pacman --noconfirm -S \
       vim \
       emacs
