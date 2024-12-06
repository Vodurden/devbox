#!/usr/bin/env bash
#
# Usage: proton-run game.exe <command>
#
#

PROCNAME=$1
COMMAND=$2

if [ -z "$PROCNAME" ]; then
    echo "a process name must be provided"
    exit 1
fi

if [ -z "$COMMAND" ]; then
    echo "<command> must be provided"
    exit 1
fi

PID=$(pidof "$PROCNAME")
if [ -z "$PID" ]; then
    echo "Could not find PID for '$PROCNAME'. Is it running?"
    exit 1
fi

export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam"
if [ ! -d "${STEAM_COMPAT_CLIENT_INSTALL_PATH}" ]; then
    echo "Invalid STEAM_COMPAT_CLIENT_INSTALL_PATH: ${STEAM_COMPAT_CLIENT_INSTALL_PATH}"
    exit 1
fi

WINEFSYNC=1
WINEPREFIX=$(perl -ne 'print "$1" if /WINEPREFIX=([^\0]+)/' /proc/$PID/environ)
WINEBIN="$(dirname "$(readlink -f /proc/$PID/exe)")"/wine


# steam-run WINEFSYNC=1 WINEPREFIX=$(perl -ne 'print "$1" if /WINEPREFIX=([^\0]+)/' /proc/$PID/environ) "$WINEBIN" "$COMMAND"

steam-run sh <<EOF
echo "Running: WINEFSYNC=1 WINEPREFIX="$WINEPREFIX" "$WINEBIN" $COMMAND"
WINEFSYNC=1 WINEPREFIX="$WINEPREFIX" "$WINEBIN" $COMMAND
EOF

# export STEAM_COMPAT_DATA_PATH="$HOME/.steam/root/steamapps/compatdata/${APPID}"
# if [ ! -d "${STEAM_COMPAT_DATA_PATH}" ]; then
#     echo "Invalid STEAM_COMPAT_DATA_PATH: ${STEAM_COMPAT_DATA_PATH}"
#     echo
#     echo "Have you run this game at least once from Steam?"
#     exit 1
# fi


# export WINEPREFIX="${STEAM_COMPAT_DATA_PATH}/pfx"
# if [ ! -d "${WINEPREFIX}" ]; then
#     echo "Invalid WINEPREFIX: ${WINEPREFIX}"
#     exit 1
# fi

# PROTON_VERSION=$(cat "${STEAM_COMPAT_DATA_PATH}/version")
# case $PROTON_VERSION in
#     "5.0-3")
#         export PROTON_FOLDER="Proton 5.0"
#         ;;
#     "6.3-3")
#         export PROTON_FOLDER="Proton 6.3"
#         ;;
#     *)
#         echo "Unknown version: $PROTON_VERSION"
#         exit 1
#         ;;
# esac

# PROTON="${STEAM_COMPAT_CLIENT_INSTALL_PATH}/root/steamapps/common/${PROTON_FOLDER}/proton"
# if [ ! -f "$PROTON" ]; then
#     echo "No proton installation found at: $PROTON"
#     exit 1
# fi

# export SteamGameId=$APPID
# export SteamAppId=$APPID
# echo "Running: $PROTON run \"$COMMAND\""
# "$PROTON" run "$COMMAND"
