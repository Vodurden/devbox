#!/bin/sh

rm -rf build \
    && packer build freebsd.json \
    && vagrant box add --force devbox-freebsd build/devbox-freebsd.box
