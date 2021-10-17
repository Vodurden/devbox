{ stdenv, lib, writeTextFile, writeShellScriptBin, fetchurl, winetricks, xvfb-run, xdotool }:

let
  dotnet40 = fetchurl {
    url = https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe;
    sha256 = "sha256-ZeBkJY8uQYgWswT2Rv+eh68QHkyVUqsGS7dNKBw4ZZ8=";
  };

  dotnet48 = fetchurl {
    url = https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe;
    sha256 = "sha256-lYidbePyBwwHeQrWzyAA0z2aG9/Go4FyWrgqscMU/VM=";
  };

  xvfbRun = name: command: "${xvfb-run}/bin/xvfb-run ${writeShellScriptBin "xvfb-run-${name}" ''
    ${command}
  ''}";

  # wineGui = name: command: "${xvfb-run}/bin/xvfb-run ${writeScript "winegui-${name}" ''
  #   wine ${command}
  # ''}";

  runTrick = trick: "${xvfb-run}/bin/xvfb-run ${writeShellScriptBin "winetrick-${trick}" ''
    export XDG_DATA_HOME=$(pwd)/data
    export XDG_CACHE_HOME=$(pwd)/cache
    export WINEARCH=win64
    export WINEPREFIX="$(realpath .)/prefix"
    winetricks --unattended --force ${trick}
  ''}";

  win10Reg = writeTextFile {
    name = "win10.reg";
    text = ./win10.reg;
  };
in

{
  wine,
  baseName,
  tricks ? []
}: stdenv.mkDerivation {
  name = "${baseName}-wine-prefix";


# echo "* Installing net48"
# winetricks --force dotnet48

# echo "* Installing faudio (i.e xaudio2_7)"
# winetricks --force faudio

# echo "* Installing vcrun2015"
# winetricks --force vcrun2015

  unpackPhase = "true";

  buildInputs = [ wine winetricks ];

  buildPhase = ''
    mkdir -p $(pwd)/{data,cache}
    export XDG_DATA_HOME=$(pwd)/data
    export XDG_CACHE_HOME=$(pwd)/cache

    # Create the prefix
    export HOME="$(mktemp -d)"
    export WINEARCH=win32
    export WINEPREFIX="$(realpath .)"/prefix
    echo "WINEPREFIX: $WINEPREFIX"
    ${wine}/bin/wineboot -i

    ${lib.concatMapStringsSep "\n\n" (trick: trick.run wine) tricks}
  '';

    # ${wineGui "dotnet40" dotnet40}
    # ${xvfbRun "wineboot" "${wine}/bin/wineboot -i"}
    # ${xvfbRun "wineconsole" "${wine}/bin/wineconsole --backend=curses cmd /c exit"}
    # ${wine}/bin/wineconsole --backend=curses cmd /c exit

    # Before running winetricks we need to make sure any dependencies are downloaded
    # ${wine}/bin/wine regedit ${win10Reg}


    # # Run our winetricks

    # ${lib.concatMapStringsSep "\n" runTrick tricks}

  installPhase = ''
    mkdir -p $out
    mv prefix $out/prefix
  '';
}
