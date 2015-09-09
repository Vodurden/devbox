#!/bin/sh

echo
echo 'Applying files/'

find /tmp/files -type f -exec grep -Iq . {} \; -and -exec dos2unix {} \;
find /tmp/files/usr/home/jake -exec chown jake {} \;

rsync -rltD /tmp/files/ / \
      && $(rm -rf /tmp/files || true)
