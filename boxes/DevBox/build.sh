#!/bin/sh

vagrant up \
    && rm -rf build \
    && mkdir build \
    && vagrant package --output build/devbox.box \
    && vagrant box add --force devbox build/devbox.box
