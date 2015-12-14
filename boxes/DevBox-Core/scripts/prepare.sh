#!/bin/sh

# Use UTF-8 locale
localectl set-locale LANG=en_US.UTF-8

# Update system
yes | pacman -Syyu

# Fix pacman keyring signing errors
# See: https://www.archlinux.org/news/gnupg-21-and-the-pacman-keyring/
yes | pacman -S haveged
systemctl start haveged
systemctl enable haveged

rm -R /etc/pacman.d/gnupg/
rm -R /root/.gnupg/  # only if the directory exists
gpg --refresh-keys
pacman-key --init && pacman-key --populate
pacman-key --refresh-keys

# Prepare dos2unix and rsync - needed for `apply_files.sh`
pacman --noconfirm -S rsync dos2unix curl
