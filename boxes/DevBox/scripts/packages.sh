#!/bin/bash

# Fix protocol error
chmod 777 /var/cache/pacman/pkg

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
       markdown \
       ruby

# Install dialyxir so we can statically analyse elixir!
git clone https://github.com/jeremyjh/dialyxir.git /tmp/dialyxir \
    && cd /tmp/dialyxir \
    && mix archive.build \
    && mix archive.install \
    && mix dialyzer.plt \
    && rm -rf /tmp/dialyxir

# Install node packages for spacemacs javascript support
runuser -l jake -c 'sudo npm install -g tern js-beautify'

# Install bundler for our jake user
runuser -l jake -c 'gem install bundler'
