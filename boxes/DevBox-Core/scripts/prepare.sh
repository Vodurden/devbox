#!/bin/sh

echo
echo 'Setting up Ports...'
# Install ports
# Lie to portsnap. Portsnap will yell at you if you're non interactive
# and tell you to use `portsnap cron`. We don't really want to wait
# between 1-3600 seconds to initialize the machine and we're not
# deploying this to a fleet so instead we're going to lie and say
# we really are interactive. Please don't hurt me BSD gods :(
portsnap --interactive fetch
portsnap extract

echo 'WITH_PKGNG=yes' >> /etc/make.conf

# Install portmaster. All future ports should use portmaster
# instead of manually building ports.
cd /usr/ports/ports-mgmt/portmaster \
    && make install -DBATCH clean \
    && cd -

# Automagically configure ports
cd /usr/ports/ports-mgmt/portconf \
    && make install -DBATCH clean \
    && cd -

# Prepare dos2unix and rsync - needed for `apply_files.sh`
portmaster net/rsync converters/unix2dos ftp/curl
