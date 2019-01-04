Introduction
============
This repository contains scripts to provision my development environment. Currently it supports *Nixos*, *Nixos + Vagrant* and *Mac*

Requirements
============

On Windows:

- A bash-compatible terminal (I'm using Msys2)
- VirtualBox
- Vagrant on the path
- vagrant-disksize plugin installed (`vagrant plugin install vagrant-disksize`)

On Mac:

- Nix

On Nixos:

- Nothing, everything is included with Nixos

Installation
=====

On Windows:

- Load the VM by executing `vagrant up`
- Log in to the vm as `vagrant`/`vagrant`
- Log in as `jake` (no password)
- Execute `sudo auto/install-nixos-system vagrant`
- Execute `auto/install-nixos-home`

On Mac:

- Execute `sudo auto/install-osx-system`
- Execute `auto/install-osx-work-home`

On Nixos + Metabox:

- Execute `sudo auto/install-nixos-system metabox`
- Execute `auto/install-nixos-home metabox`

On Nixos + T420:

- Execute `sudo auto/install-nixos-system t420`
- Execute `auto/install-nixos-home metabox`

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
