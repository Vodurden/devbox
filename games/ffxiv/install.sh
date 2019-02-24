#!/usr/bin/env nix-shell
#! nix-shell -i bash -p wineUnstableEnv curl

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="${HOME}/Games/ffxiv"
WINEPREFIX="${INSTALL_DIR}/wine"
WINEARCH="win64"

echo "* Installing FFXIV to ${INSTALL_DIR}"
mkdir -p ${INSTALL_DIR}

echo "* FFXIV setup found?"
FFXIV_SETUP_PATH="${INSTALL_DIR}/ffxivsetup.exe"
if [ -f "${FFXIV_SETUP_PATH}" ]; then
  echo "* Yes! FFXIV setup found at ${FFXIV_SETUP_PATH}. Skipping download."
else
  echo "* No! Downloading FFXIV setup to ${FFXIV_SETUP_PATH}"
  curl http://gdl.square-enix.com/ffxiv/inst/ffxivsetup.exe > "${FFXIV_SETUP_PATH}"
fi

echo "* FFXIV install found?"
FFXIV_INSTALL_PATH="${WINEPREFIX}/drive_c/Program Files (x86)/SquareEnix/FINAL FANTASY XIV - A Realm Reborn"
if [ -d "${FFXIV_INSTALL_PATH}" ]; then
  echo "* Yes! FFXIV install found at ${FFXIV_INSTALL_PATH}"
else
  echo "* No! Preparing to launch FFXIV setup"
  echo
  echo "  This will open a GUI launcher. You _must_:"
  echo
  echo "    - Select any install language"
  echo "    - Install DirectX when asked"
  echo "    - Install to the default directory (C:\Program Files (x86))"
  echo
  sleep 3
  echo "Launching ffxivsetup ..."
  WINEPREFIX="${WINEPREFIX}" WINARCH="${WINARCH}" wine "${FFXIV_SETUP_PATH}"
fi

echo "* DXVK setup found?"
DXVK_VERSION="0.96"
DXVK_SETUP_PATH="${INSTALL_DIR}/dxvk-${DXVK_VERSION}"
if [ -d "${DXVK_SETUP_PATH}" ]; then
  echo "* Yes! DXVK setup found at ${DXVK_SETUP_PATH}. Skipping download. "
else
  echo "* No! Downloading DXVK ... "
  curl -L -o - "https://github.com/doitsujin/dxvk/releases/download/v${DXVK_VERSION}/dxvk-${DXVK_VERSION}.tar.gz" | tar -xzf - -C "${INSTALL_DIR}"
fi

echo "* Installing DXVK"
WINEPREFIX="${WINEPREFIX}" WINARCH="${WINARCH}" winetricks --force "${DXVK_SETUP_PATH}/setup_dxvk.verb"

FFXIV_BOOT_CFG_PATH="${WINEPREFIX}/drive_c/users/${USER}/My Documents/My Games/FINAL FANTASY XIV - A Realm Reborn/FFXIV_BOOT.cfg"
if [ ! -f "${FFXIV_BOOT_CFG_PATH}" ]; then
  echo "* Launching FFXIV to create FFXIV_BOOT.cfg"
  echo "  This will open a GUI. You _must_:"
  echo
  echo "    - Accept the license agreement"
  echo "    - Log in with your SQUARE account"
  echo "    - Close the client. If the client crashes at this point this is fine :)"
  echo
  sleep 3
  WINEPREFIX="${WINEPREFIX}" WINARCH="${WINARCH}" wine "${FFXIV_INSTALL_PATH}/boot/ffxivboot.exe"
fi;

echo "* FFXIV Settings tweak: Setting BrowserType to 2 in FFXIV_BOOT.cfg"
sed -i -e 's/BrowserType[[:space:]][[:digit:]]/BrowserType 2/' "${FFXIV_BOOT_CFG_PATH}"

echo "* FFXIV Settings tweak: Setting DX11Enabled to 1 in FFXIV_BOOT.cfg"
sed -i -e 's/DX11Enabled[[:space:]][[:digit:]]/DX11Enabled 1/' "${FFXIV_BOOT_CFG_PATH}"

echo "* Installing ffxiv.sh shortcut under ${INSTALL_DIR}"
cp "${SOURCE_DIR}/ffxiv.sh" "${INSTALL_DIR}/ffxiv.sh"
chmod +x "${INSTALL_DIR}/ffxiv.sh"
