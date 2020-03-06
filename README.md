Introduction
============
This repository contains scripts to provision my development environment. Currently it supports *NixOS*

Installation
============

On NixOS:

- Execute `auto/install {machine-name}`

After installation `nixos-rebuild` and `home-manager` will automatically use the correct machine configuration regardless of the current working directory.

Directory Structure
===================

    .
    +-- auto                Automation scripts used to install and update the devbox
    +-- doc                 Documentation
    +-- games               Scripts to force specific games run on linux
    +-- machines            Machine-specific configuration. Contains the root-level configuration.nix and home.nix
    +-- nix                 All nix configuration


References
==========

I stole a lot of ideas from these repos:

- https://github.com/jkachmar/dotnix
- https://github.com/srid/nix-config
- https://github.com/cprussin/dotfiles
- https://gist.github.com/CMCDragonkai/de84aece83f8521d087416fa21e34df4
