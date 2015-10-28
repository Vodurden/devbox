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
       clang cmake \
       nodejs npm \
       erlang erlang-docs elixir \
       lua \
       rust \
       markdown

# Install dialyxir so we can statically analyse elixir!
git clone https://github.com/jeremyjh/dialyxir.git /tmp/dialyxir \
    && cd /tmp/dialyxir \
    && mix archive.build \
    && mix archive.install \
    && mix dialyzer.plt \
    && rm -rf /tmp/dialyxir

# Install node packages for spacemacs javascript support
npm install -g tern js-beautify

# Install bundler for our jake user
runuser -l jake -c 'gem install bundler'
