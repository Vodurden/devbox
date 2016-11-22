#!/bin/bash

# Make sure our .spacemacs is clean
echo 'Cleaning .spacemacs'
mv /tmp/.spacemacs /home/jake/.spacemacs
dos2unix -q /home/jake/.spacemacs
chown jake:jake /home/jake/.spacemacs

# Install Spacemacs. When updating Spacemacs modify the `--branch <tag>` portion of the runuser command to point to the new version tag.
echo 'Installing Spacemacs'

runuser -l jake -c 'git clone --recursive https://github.com/syl20bnr/spacemacs --branch v0.200.2 ~/.emacs.d'

# We must switch to the users home directory before running init.el
# or gpg will fail to find it's keys and we won't be able to
# download any packages.
echo 'Opening Emacs to force Spacemacs Bootstrapping'
runuser -l jake -c 'cd ~/ && emacs --batch -l ~/.emacs.d/init.el'

echo 'And Again'
runuser -l jake -c 'cd ~/ && emacs --batch -l ~/.emacs.d/init.el'

echo 'Spacemacs Done'
