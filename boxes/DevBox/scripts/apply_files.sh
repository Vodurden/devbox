#!/bin/sh

echo
echo 'Applying files/'

# Install dos2unix so we can get rid of any CR's
cd /usr/ports/converters/unix2dos \
    && make install -DBATCH clean \
    && cd -

# Remove unix line endings from anything in /tmp/files
find /tmp/files -type f -exec grep -Iq . {} \; -and -exec dos2unix {} \;
/bin/cp -a -f /tmp/files/. /
