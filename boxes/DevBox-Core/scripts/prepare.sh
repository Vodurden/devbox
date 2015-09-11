#!/bin/sh

pacman --noconfirm -Syy

# Prepare dos2unix and rsync - needed for `apply_files.sh`
pacman --noconfirm -S rsync dos2unix curl
