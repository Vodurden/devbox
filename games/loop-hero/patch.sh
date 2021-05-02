#!/usr/bin/env nix-shell
#! nix-shell -i bash -p
set -euo pipefail

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="/media/SteamLibrary/steamapps/common/Loop Hero"

cp "${SOURCE_DIR}/run.sh" "${INSTALL_DIR}/run.sh"
