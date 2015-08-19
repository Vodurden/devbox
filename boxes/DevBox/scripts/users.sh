#!/bin/sh

# Add the Jake account. No password
echo 'jake::::::Jake Woods:/usr/home/jake:tcsh:none' > /tmp/users
adduser -w none -G wheel -f /tmp/users
rm /tmp/users

# Give the jake account sudo access
echo 'jake ALL=(ALL) NOPASSWD: ALL' > /usr/local/etc/sudoers.d/jake
