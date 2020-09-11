{ pkgs, lib, stdenv, makeDesktopItem,

  dpkg, autoPatchelfHook,

  makeWrapper, nodejs, yarn, electron_7,

  glib, glibc, gnome3, gcc-unwrapped, nss, libX11, xorg, libXScrnSaver, alsaLib, nspr
}:

let
  baseName = "tuxedo-control-center";
  version = "1.0.4";

  # packageName = lib.concatStrings (
  #   map (entry: (lib.concatStrings (lib.mapAttrsToList (key: value: "${key}-${value}") entry))) (lib.importJSON ./package.json)
  # );

  baseNodeDependencies = (import ./node-dependencies {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  }).package;

  nodeDependencies = baseNodeDependencies.override {
    dontNpmInstall = true;
  };

  desktopItem = makeDesktopItem {
    name = "tuxedo-control-center";
    exec = "tuxedo-control-center %U";
    comment = "TUXEDO Control Center Application";
    desktopName = "TUXEDO Control Center";
    icon = "tuxedo-control-center";
    categories = "System;";
  };

in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = builtins.fetchGit {
    url = git://github.com/tuxedocomputers/tuxedo-control-center;
    rev = "1919006c5bf758919f85afe4689b875b82aa506d";
  };

  buildInputs = [
    nodejs

    nodeDependencies
  ];


    # ln -s ${nodeDependencies.package}/lib/node_modules ./node_modules
    # export PATH="${nodeDependencies.package}/bin:$PATH"

    # echo "PATHS: ."
    # ls .

    # echo "PATHS: NODE MODULES"
    # ls ./node_modules/tuxedo-control-center/node_modules/

    # mkdir -p node_modules/@types
    # ln -s ${nodeDependencies."@types/node"}/lib/node_modules/@types/node ./node_modules/@types/node

  buildPhase = ''

    echo "ls"
    ls

    npm run clean
    npm run build-electron
    # npm run build-service
    # npm run build-native
    # npm run build-ng
    # npm run copy-files
  '';

  installPhase = ''
    mkdir $out
    cp -R . $out
  '';
}
# stdenv.mkDerivation rec {
#   name = "${baseName}-${version}";

#   src = builtins.fetchGit {
#     url = git://github.com/tuxedocomputers/tuxedo-control-center;
#     rev = "1919006c5bf758919f85afe4689b875b82aa506d";
#   };

#   buildInputs = [ nodejs ];

#   buildPhase = ''
#     npm build
#   '';

#   installPhase = ''
#     mkdir $out
#     cp -R . $out
#   '';

#   meta = with stdenv.lib; {
#     description = "Tuxedo Control Center";
#     # homepage = https://www.wolfram.com/wolframscript/;
#     # license = licenses.mit;
#     # maintainers = with stdenv.lib.maintainers; [ ];
#     # platforms = [ "x86_64-linux" ];
#   };
# }


# nodePackages."tuxedo-control-center".override {
#   nativeBuildInputs = [ pkgs.makeWrapper ];
# }
