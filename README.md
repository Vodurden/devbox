Introduction
============
This repository contains scripts to provision my development environment. Currently it supports *Nixos*, *Nixos + Vagrant* and *Mac*

Requirements
============

On Windows:

- A bash-compatible terminal (I'm using Msys2)
- VirtualBox
- Vagrant on the path

On Mac:

- Nix

On Nixos:

- Nothing, everything is included with Nixos

Installation
=====

On Windows:

- Load the VM by executing `vagrant up`
- Log in to the vm as `vagrant`/`vagrant`
- Execute `sudo auto/install-vagrant-system`
- Log in as `jake` (no password)
- Execute `auto/install-nixos-home`

On Mac:

- Execute `auto/install-osx-work-home`

On Nixos + T420:

- Execute `sudo auto/install-t420-system`
- Execute `auto/install-nixos-home`

Development Flow
----------------

On Mac:

- Open Emacs

On Nixos:

- Login: `jake`
- Use `Alt+P` to open programs. I recommend `emacs`
- Use `Alt+Shift+Enter` to open a terminal


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
