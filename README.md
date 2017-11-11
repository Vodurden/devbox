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

- Python (use brew)
- Ansible

On Nixos:

- Just nixos

Usage
=====

On Windows:

- Execute `auto/vagrant.sh`

On Mac:

- Execute `auto/macosx-rea.sh`

Development Flow
----------------

On Mac:

- Open Emacs

On Debian:

- Login: `jake`
- Use `Alt+P` to open problems. I recommend `emacs`
- Use `Alt+Shift+Enter` to open a terminal

At this point we should have a fullscreen emacs. Use `Alt+1` and `Alt+2` to swap between Emacs/Terminal (or use emacs's terminal).

Directory Structure
===================

    .
    +-- ansible             Ansible provisoning scripts applied when running ansible.
    |   |
    |   +-- roles           Roles to mix together for each machine. Defines some capability
    |   |                   we want the machine to have.
    |   |
    |   +-- shared_tasks    Common ansible tasks that are used by many roles
    |
    +-- auto                Automation scripts used to run/provision the devbox
    |
    +-- vagrant             Files specific to the vagrant implementation of the box
