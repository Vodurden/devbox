#!/bin/bash

pacman -Sy

# Fonts
pacman --noconfirm -S \
       adobe-source-code-pro-fonts

# Tools
pacman --noconfirm -S \
       git \
       xclip \
       aspell

# Languages
pacman --noconfirm -S \
       clang \
       cmake \
       nodejs \
       npm \
       elixir \
       lua \
       rust \
       markdown

# Install bundler for our jake user
runuser -l jake -c 'gem install bundler'
