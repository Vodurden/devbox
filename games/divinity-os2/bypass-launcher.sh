#!/usr/bin/env nix-shell
#! nix-shell -i bash -p

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="${HOME}/.steam/steam/steamapps/common/Divinity Original Sin 2"

SUPPORT_TOOL_PATH="${INSTALL_DIR}/DefEd/bin/SupportTool.exe"
EOCAPP_PATH="${INSTALL_DIR}/DefEd/bin/EoCApp.exe"

# The launcher doesn't work in wine, but the rest of the game does! So we just replace the launcher
# executable with a symlink to the game.
#
# We need to re-run this whenever the game is updated as steam will replace our symlink with the launcher.
echo "Bypassing Divinity Original Sin 2 Launcher:"

echo -n "* Checking if bypass is already in place ... "
if [[ -L "${SUPPORT_TOOL_PATH}" ]]; then
  echo "yes!"
  echo "* Nothing to do"
  exit 0
else
  echo "no!"
fi

echo -n "* Backing up SupportTool.exe to SupportTool.exe.bak ..."
cp "${SUPPORT_TOOL_PATH}" "${SUPPORT_TOOL_PATH}.bak"
echo "done!"

echo -n "* Linking SupportTool.exe to EoCApp.exe ..."
ln -sf "${EOCAPP_PATH}" "${SUPPORT_TOOL_PATH}"
echo " done!"
