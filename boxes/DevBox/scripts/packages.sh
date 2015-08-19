#!/bin/sh

set +x

# Install Xorg
cd /usr/ports/x11/xorg \
    && make install -DBATCH clean \
    && cd -

cd /usr/ports/x11/xinit \
    && make install -DBATCH clean \
    && cd -

# Install Decent Fonts
cd /usr/ports/x11-fonts/urwfonts \
    && make install -DBATCH clean \
    && cd -

# Install XMonad
cd /usr/ports/x11-wm/hs-xmonad \
    && make install -DBATCH distclean \
    && cd -

cd /usr/ports/x11-wm/hs-xmonad-contrib \
    && make install -DBATCH distclean \
    && cd -
