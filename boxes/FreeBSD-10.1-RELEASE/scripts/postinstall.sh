#!/bin/sh

echo 'Running post-install..'

echo
echo 'Setting up pkg'
if [ ! -f /usr/local/sbin/pkg ]; then
  ASSUME_ALWAYS_YES=yes pkg bootstrap
fi

echo
echo 'Setting up sudo..'
pkg install -y sudo
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /usr/local/etc/sudoers.d/vagrant

echo
echo 'Setting up the vagrant ssh keys'
mkdir ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > ~vagrant/.ssh/authorized_keys
chown -R vagrant ~vagrant/.ssh
chmod 600 ~vagrant/.ssh/authorized_keys

echo
echo 'Changing roots shell back'
chsh -s tcsh root

# Packer bugs can cause this script to finish earlier then it should and progress to the
# next script. We're going to check that this file exists in the next script which ensures
# that the entire script has run.
#
# see: https://github.com/mitchellh/packer/issues/2631
touch /tmp/postinstall_good

echo
echo 'Post-install complete.'
