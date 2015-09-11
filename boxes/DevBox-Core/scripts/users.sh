#!/bin/sh

# Enable 'wheel' as sudo access
echo 'Enabling Wheel=Sudo'
sed -i -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# Add the Jake account. No password
echo 'Creating Jake'
useradd -c 'Jake Woods' -m -G wheel jake
passwd -d jake # No password for the jake account
echo 'Done'
