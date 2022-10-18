#!/usr/bin/env nix-shell
#! nix-shell -i bash -p wineWowPackages.full winetricks curl unzip

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INSTALL_DIR="${HOME}/Games/ffxiv"

export WINEPREFIX="${INSTALL_DIR}/wine"
export WINEARCH="win64"

FFXIV_SETUP_PATH="${INSTALL_DIR}/ffxivsetup.exe"
FFXIV_INSTALL_PATH="${WINEPREFIX}/drive_c/Program Files (x86)/SquareEnix/FINAL FANTASY XIV - A Realm Reborn"

echo "* XIVLauncher setup found?"
XIV_LAUNCHER_VERSION="6.2.44"
XIV_LAUNCHER_SETUP_PATH="${INSTALL_DIR}/XIVLauncherSetup.nupkg"
if [ -f "${XIV_LAUNCHER_SETUP_PATH}" ]; then
  echo "* Yes! XIVLauncher setup found at ${XIV_LAUNCHER_SETUP_PATH}. Skipping download. "
else
  echo "* No! Downloading XIVLauncher..."
  curl -L -o - "https://github.com/goatcorp/FFXIVQuickLauncher/releases/download/${XIV_LAUNCHER_VERSION}/XIVLauncher-${XIV_LAUNCHER_VERSION}-full.nupkg" > "${XIV_LAUNCHER_SETUP_PATH}"
fi

echo "* Installing XIVLauncher"
cp "${XIV_LAUNCHER_SETUP_PATH}" "${INSTALL_DIR}/XIVLauncherSetup.zip"
rm -rf "${INSTALL_DIR}/XIVLauncherSetup"
unzip "${INSTALL_DIR}/XIVLauncherSetup.zip" -d "${INSTALL_DIR}/XIVLauncherSetup"

echo "* Installing XIVLauncher to ${FFXIV_INSTALL_PATH}/XIVLauncher-${XIV_LAUNCHER_VERSION}"
cp -r "${INSTALL_DIR}/XIVLauncherSetup/lib/net45" "${FFXIV_INSTALL_PATH}/XIVLauncher-${XIV_LAUNCHER_VERSION}"

# echo "* Launching XIVLauncher"
# wine64 "${FFXIV_INSTALL_PATH}/XIVLauncher/XIVLauncher.exe"

# echo "* Installing XIVLauncher"
# WINEPREFIX="${WINEPREFIX}" WINARCH="${WINARCH}" wine "${XIV_LAUNCHER_SETUP_PATH}"
