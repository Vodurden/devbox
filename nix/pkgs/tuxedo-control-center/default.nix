{ pkgs, lib, stdenv, makeDesktopItem,

  dpkg, autoPatchelfHook,

  mkYarnPackage, python,

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
    # Electron tries to download itself if this isn't set. We don't
    # like that in nix so let's prevent it.
    #
    # This means we have to provide our own electron binaries when
    # wrapping this program.
    ELECTRON_SKIP_BINARY_DOWNLOAD=1;

    # Angular prompts for analytics if we don't set this variable which
    # causes the nix build to error for some reason.
    #
    # We can disable analytics using false or empty string
    # (See https://github.com/angular/angular-cli/blob/1a39c5202a6fe159f8d7db85a1c186176240e437/packages/angular/cli/models/analytics.ts#L506)
    NG_CLI_ANALYTICS="false";
  };

  nodeModules = "${nodeDependencies}/lib/node_modules/tuxedo-control-center/node_modules";

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
    nodeDependencies

    nodejs
    makeWrapper

    # For node-gyp
    python
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
    # TODO: use `nodeDependencies` attribute of `node2nix` output when a new version of `node2nix`
    # is released. Version `1.8.0` doesn't have the attribute.
    ln -s ${nodeModules} ./node_modules
    export PATH="${nodeModules}/.bin:$PATH"

    echo "ls"
    ls

    echo
    echo "ls node-dependencies/lib/node_modules/tuxedo-control-center/node_modules/.bin"
    ls "${nodeDependencies}/lib/node_modules/tuxedo-control-center/node_modules/.bin"

    mkdir -p ./pkg-cache
    export PKG_CACHE_PATH=./pkg-cache

    # The order of `npm` commands matches what `npm run build-prod` does but we split it out
    # so we can customise the native builds in `npm run build-service`.
    npm run clean
    npm run build-electron

    # We don't use `npm run build-service` here because it uses `pkg` which packages node binaries
    # in a way unsuitable for nix. Instead we're doing it ourself.
    tsc -p ./src/service-app
    cp ./src/package.json ./dist/tuxedo-control-center/service-app/package.json

    # We need to tell npm where to find node or `node-gyp` will try to download it.
    # This also _needs_ to be lowercase or `npm` won't detect it
    export npm_config_nodedir=${nodejs}
    npm run build-native
    cp ./build/Release/TuxedoWMIAPI.node ./dist/tuxedo-control-center/service-app/

    # npm run build-native
    # npm run build-ng-prod
  '';

  installPhase = ''
    mkdir -p $out/src
    cp -R . $out/src

    ls $out/
    cp -r dist/tuxedo-control-center/service-app $out/tccd
    cp -r dist/tuxedo-control-center/e-app $out/control-center

    ln -s ${nodeModules} $out/node_modules

    makeWrapper ${nodejs}/bin/node $out/bin/tccd \
                --add-flags "$out/tccd/service-app/main.js" \
                --prefix NODE_PATH : $out/tccd \
                --prefix NODE_PATH : $out/node_modules

    # makeWrapper ${nodejs}/bin/node $out/new-bin/tccd \
    #   --add-flags "$out/dist/tuxedo-control-center/service-app/service-app/main.js"
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
