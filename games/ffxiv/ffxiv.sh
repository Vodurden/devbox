#!/usr/bin/env nix-shell
#! nix-shell -i bash -p wineFull

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WINEPREFIX="${SOURCE_DIR}/wine"
WINEARCH="win64"
FFXIV_INSTALL_PATH="${WINEPREFIX}/drive_c/Program Files (x86)/SquareEnix/FINAL FANTASY XIV - A Realm Reborn"

WINEPREFIX="${WINEPREFIX}" WINEARCH="${WINEARCH}" wine "${FFXIV_INSTALL_PATH}/XIVLauncher/XIVLauncher.exe"
