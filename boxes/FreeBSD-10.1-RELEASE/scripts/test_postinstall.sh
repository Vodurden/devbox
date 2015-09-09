#!/bin/sh

echo 'Testing Postinstall'

if [ ! -f /tmp/postinstall_good ] ; then
    echo 'Cannot find /tmp/postinstall_good. Assume that this build failed.'
    echo 'To fix: re-run the build. Keep postinstall.sh fast & small'
    echo ''
    echo 'See: https://github.com/mitchellh/packer/issues/2631'
    exit 1
fi

echo 'Build Good!'
