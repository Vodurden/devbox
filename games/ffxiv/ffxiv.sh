#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/81cef6b70fb5d5cdba5a0fef3f714c2dadaf0d6d.tar.gz -i bash -p gamemode -p wineWowPackages.full -p "(callPackage (fetchGit { url = \"https://github.com/guibou/nixGL\"; rev = \"047a34b2f087e2e3f93d43df8e67ada40bf70e5c\"; }) {}).nixVulkanIntel"

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export WINEPREFIX="${SOURCE_DIR}/wine"
export WINEARCH="win64"
export XL_WINEONLINUX=true
FFXIV_INSTALL_PATH="${WINEPREFIX}/drive_c/Program Files (x86)/SquareEnix/FINAL FANTASY XIV - A Realm Reborn"

nixVulkanIntel gamemoderun wine "${FFXIV_INSTALL_PATH}/XIVLauncher-6.1.19/XIVLauncher.exe"
