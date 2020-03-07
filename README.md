Introduction
============
This repository contains scripts to provision my development environment. Currently it supports *NixOS*

Installation
============

On NixOS:

- Execute `auto/install {machine-name}`

After installation `nixos-rebuild` will automatically use the correct machine configuration regardless of the current working directory.

Directory Structure
===================

    .
    +-- auto                      Automation scripts used to install and update the devbox
    +-- config                    All configurations describing my machines
      +-- machines                Machine specific config. Each contains a configuration.nix and any machine-specific configuration files
      +-- modules                 All configuration modules. Each module may contain both nixos and home-manager configuration
    +-- machines                  Machine-specific configuration. Contains the root-level configuration.nix and home.nix
    +-- doc                       Documentation
    +-- games                     Scripts to force specific games run on linux
    +-- nix                       Nix extensions for nixpkgs, nixos and home-manager
      +-- modules                 Custom modules for nixos and home-manager providing missing programs and systems. Some of these modules may become PRs to nixos and home-manager if they're useful enough.
      +-- overlays                Custom overlays for nixpkgs, typically used to merge custom packages into <nixpkgs>
      +-- pkgs                    Custom packages for nixpkgs


References
==========

I stole a lot of ideas from these repos:

- https://github.com/jkachmar/dotnix
- https://github.com/srid/nix-config
- https://github.com/cprussin/dotfiles
- https://gist.github.com/CMCDragonkai/de84aece83f8521d087416fa21e34df4
