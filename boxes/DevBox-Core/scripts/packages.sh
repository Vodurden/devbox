#!/bin/sh

portmaster -y --no-confirm -d -mBATCH=yes --packages-build --delete-build-only \
    devel/ncurses \
    x11/xorg \
    x11-fonts/urwfonts \
    x11/rxvt-unicode \
    x11-wm/hs-xmonad \
    x11-wm/hs-xmonad-contrib

pkg install -y \
    editors/vim \
    editors/emacs
