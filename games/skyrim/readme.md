# Skyrim

1. Set launch options to `WINEDLLOVERRIDES="xaudio2_7=n,b" %command%` (fixes missing NPC audio)
2. Install `dotnet48` (had to use a newer version of wine) `nix-shell -p wineWowPackages.unstable` > `WINE="$(which wine)" protontricks 489830 dotnet48`
