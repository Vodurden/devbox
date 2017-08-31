Introduction
============
This repository contains scripts to provision my development environment. Currently I support *Mac* and *Debian on VirtualBox*

Most of the work is done to provide a consistent environment for my spacemacs configuration to run in. (https://github.com/syl20bnr/spacemacs)

Requirements
============

On Windows:

- A bash-compatible terminal (I'm using Msys2)
- VirtualBox
- Vagrant on the path

On Mac:

- Python (use brew)
- Ansible

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
- Open a GUI: `startx`
- Open a Terminal: `Alt+Shift+Enter`
- Move the Terminal to Screen 2: `Alt+Shift+2`
- Move to Screen 2: `Alt+2`
- Open Emacs: `(emacs &>/dev/null &)`
- Move Emacs to Screen 1: `Alt+Shift+1`
- Move to Screen 1: `Alt+1`

At this point we should have a fullscreen emacs. Use `Alt+1` and `Alt+2` to swap between Emacs/Terminal (or use emacs's terminal).

Useful Information
------------------

On Debian:

- Login: `jake` (no password)
- Start GUI/xmonad: `startx`
- Start emacs: `(emacs &>/dev/null &)`

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
