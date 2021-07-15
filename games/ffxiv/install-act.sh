#!/usr/bin/env nix-shell
#! nix-shell -i bash -p wineWowPackages.full winetricks curl unzip

set -euo pipefail
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="${HOME}/Games/ffxiv"

export WINEPREFIX="${INSTALL_DIR}/wine"
export WINEARCH="win64"

echo "* ACT setup found?"
ACT_VERSION="3.5.0.273"
ACT_SETUP_PATH="${INSTALL_DIR}/ACTv${ACT_VERSION}-setup.exe"
if [ -d "${ACT_SETUP_PATH}" ]; then
    echo "* Yes! ACT setup found at ${ACT_SETUP_PATH}. Skipping download."
else
    curl -L -o - "https://github.com/EQAditu/AdvancedCombatTracker/releases/download/${ACT_VERSION}/ACTv3-Setup.exe" > "${ACT_SETUP_PATH}"
fi

echo "* Launching ACT Setup"
WINEPREFIX="${WINEPREFIX}" WINARCH="${WINEARCH}" wine "${ACT_SETUP_PATH}"
