#!/bin/sh

echo
echo 'Setting up VM Tools..'

# Make sure lib32 was installed during packing. VirtualBox expects it to be intalled!
# Otherwise you'll need to download and extract lib32.txz here.

# Install virtualbox additions
portmaster -y --no-confirm -d -mBATCH=yes \
    emulators/virtualbox-ose-additions

echo 'vboxguest_enable="YES"' >> /etc/rc.conf
echo 'vboxservice_enable="YES"' >> /etc/rc.conf
echo 'hald_enable="YES"' >> /etc/rc.conf
echo 'dbus_enable="YES"' >> /etc/rc.conf
