{ pkgs, lib, stdenv, makeDesktopItem,

  dpkg, autoPatchelfHook,

  mkYarnPackage, python,

  makeWrapper, nodejs, yarn, electron_8,

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
    npm run build-native   # Builds to ./build/Release/TuxedoWMIAPI.node

    npm run build-ng-prod
  '';

  installPhase = ''
    mkdir -p $out/build-output
    cp -R . $out/build-output

    cp -R ./dist/tuxedo-control-center/* $out

    ln -s ${nodeModules} $out/node_modules

    # Parts of the code expect the icons to live under `data/dist-data`. Let's just
    # copy the whole thing since the system assumes it has access to all the `dist-data`
    # files.
    mkdir -p $out/data/dist-data
    cp -R ./src/dist-data/* $out/data/dist-data/

    # Install `tccd`
    mkdir -p $out/data/service
    cp ./build/Release/TuxedoWMIAPI.node $out/data/service/TuxedoWMIAPI.node
    makeWrapper ${nodejs}/bin/node $out/data/service/tccd \
                --add-flags "$out/service-app/service-app/main.js" \
                --prefix NODE_PATH : $out/data/service \
                --prefix NODE_PATH : $out/node_modules
    mkdir -p $out/bin
    ln -s $out/data/service/tccd $out/bin/tccd

    # Install `tuxedo-control-center`
    makeWrapper ${electron_8}/bin/electron $out/bin/tuxedo-control-center \
                --add-flags "$out/e-app/e-app/main.js" \
                --add-flags "--no-tccd-version-check" \
                --prefix NODE_PATH : $out/node_modules

    # Install the bits of `$out/data/dist-data` into the FHS-appropriate locations
    mkdir -p $out/usr/share/applications
    cp $out/data/dist-data/tuxedo-control-center.desktop $out/usr/share/applications/tuxedo-control-center.desktop

    mkdir -p $out/etc/skel/.config/autostart
    cp $out/data/dist-data/tuxedo-control-center-tray.desktop \
       $out/etc/skel/.config/autostart/tuxedo-control-center-tray.desktop

    mkdir -p $out/share/polkit-1/actions/
    cp $out/data/dist-data/de.tuxedocomputers.tcc.policy $out/share/polkit-1/actions/de.tuxedocomputers.tcc.policy

    mkdir -p $out/etc/dbus-1/system.d/
    cp $out/data/dist-data/com.tuxedocomputers.tccd.conf  $out/etc/dbus-1/system.d/com.tuxedocomputers.tccd.conf
  '';
}
