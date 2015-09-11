Introduction
============
This repository contains everything needed to build my personal development environment as a virtual machine.

Most of the work is done to provide a consistent environment for my spacemacs configuration to run in. (https://github.com/syl20bnr/spacemacs)

Usage
=====
Once the project is built simply execute `vagrant up` in the root directory.

Development Flow
----------------

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

- Login: `jake` (no password)
- Start GUI/xmonad: `startx`
- Start emacs: `(emacs &>/dev/null &)`

Building
========

- Requires: Vagrant (https://www.vagrantup.com/)
- Time: ~30min

To build this project simply:

    cd boxes
    ./build.sh


Directory Structure
===================

    .
    +-- boxes
    |   +-- DevBox            Image built from DevBox-Core. Adds Languages & Tools
    |   |
    |   +-- DevBox-Core       Base Arch Image installing core packages & config
    |
    +-- files                Files applied to the machine on `vagrant up`.
    |                        Usually dotfiles
    |
    +-- scripts              Scripts executed on the machines during configuration
