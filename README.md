Introduction
============
This repository contains scripts to provision my development environment. Currently it supports *NixOS*

Installation
============

On NixOS:

- Execute `auto/install {machine-name}`

Usage
=====

After installation `nixos-rebuild` and `home-manager` will automatically use the correct machine configuration
regardless of the current working directory.

Directory Structure
===================

    .
    +-- auto                Automation scripts used to run/provision the devbox
    |
    +-- dotfiles            Dotfiles grouped by machine type
    |
    +-- nixos               Nixos configuration files
    |
    +-- nixpkgs             Nixpkgs configuration. Includes what programs are installed on the systems


References
==========

I stole a lot of ideas from these repos:

- https://github.com/jkachmar/dotnix
- https://github.com/srid/nix-config
- https://github.com/cprussin/dotfiles
- https://gist.github.com/CMCDragonkai/de84aece83f8521d087416fa21e34df4
