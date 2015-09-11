#!/bin/sh

vagrant destroy -f \
    && vagrant up \
    && rm -rf build \
    && mkdir build \
    && vagrant package --output build/devbox-core.box \
    && vagrant box add --force devbox-core build/devbox-core.box
