#!/bin/sh

packer build arch.json \
    && vagrant box add --force arch-base arch-base.box
