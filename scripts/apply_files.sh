#!/bin/sh

echo
echo 'Applying files/'

find /tmp/files -type f -exec grep -Iq . {} \; -and -exec dos2unix -q {} \;
find /tmp/files/home/jake -exec chown jake:jake {} \;

rsync -rltopgD /tmp/files/ / \
      && $(rm -rf /tmp/files || true)
