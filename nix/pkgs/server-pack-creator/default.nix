{ pkgs, lib, fetchurl, appimageTools, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "ServerPackCreator";
    exec = "ServerPackCreator";
    comment = "ServerPackCreator creates a Minecraft server pack from any given Forge, Fabric, Quilt, LegacyFabric and NeoForge modpack.";
    desktopName = "Server Pack Creator";
    categories = ["Game"];
  };
in

appimageTools.wrapType2 rec {
  name = "ServerPackCreator";
  version = "5.1.11";
  src = fetchurl {
    url = "https://github.com/Griefed/ServerPackCreator/releases/download/${version}/ServerPackCreator-${version}-Portable-Linux-x86_64.AppImage";
    sha256 = "sha256-1yF4r0nqFxHgWGtOC3OBzbY7wOcn3Cx1LkaTkDBuwYU=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share
    cp --recursive "${desktopItem}/share" "$out/"
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Griefed/ServerPackCreator";
    description = "ServerPackCreator creates a Minecraft server pack from any given Forge, Fabric, Quilt, LegacyFabric and NeoForge modpack.";
    platforms = [ "x86_64-linux" ];
    license = "unknown";
  };
}
