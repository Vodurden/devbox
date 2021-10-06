Introduction
============
This repository contains scripts to provision my development environment. 

Installation
============

NixOS: Execute `sudo nixos-rebuild switch --flake .#{machine-name}`. To update use `nix flake update`.

Home Manager (non-NixOS): `home-manager switch --flake .`

Directory Structure
===================

    .
    +-- config                    All configurations describing my machines
      +-- home-manager            Home Manager configuration modules.
      +-- machines                Machine specific config. Each contains a either configuration.nix or home.nix plus hardware configuration and any machine-specific configuration files
      +-- nixos                   Nixos configuration modules. Modules may also configure home-manager indirectly.
    +-- doc                       Documentation
    +-- games                     Scripts to force specific games run on linux
    +-- nix                       Nix extensions for nixpkgs, nixos and home-manager
      +-- lib                     Helper functions used by other nix expressions
      +-- nixos                   Custom modules for nixos providing missing programs and systems. Some of these modules may become PRs to nixos if they're useful enough.
      +-- home-manager            Custom modules for home-manager providing missing programs and systems. Some of these might become PRs to home-manager if they're useful enough.
      +-- pkgs                    Custom packages for nixpkgs
    +-- nixpkgs                   My local build of `nixpkgs`, as a git submodule


References
==========

I stole a lot of ideas from these repos:

- https://github.com/jkachmar/dotnix
- https://github.com/srid/nix-config
- https://github.com/cprussin/dotfiles
- https://gist.github.com/CMCDragonkai/de84aece83f8521d087416fa21e34df4
