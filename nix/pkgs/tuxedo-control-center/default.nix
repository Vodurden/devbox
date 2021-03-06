{ pkgs, lib, stdenv, makeDesktopItem,

  python,

  makeWrapper, nodejs, electron_8
}:

let
  baseName = "tuxedo-control-center";
  version = "1.0.4";

  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./package.json));

  baseNodePackages = (import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  });

  nodePackages = baseNodePackages."${packageName}".override {
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

  desktopItem = makeDesktopItem {
    name = "tuxedo-control-center";
    exec = "tuxedo-control-center %U";
    comment = "An application helping you to tune your TUXEDO";
    desktopName = "TUXEDO Control Center";
    icon = "tuxedo-control-center";
    categories = "System;";
  };
in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  src = "${nodePackages}/lib/node_modules/tuxedo-control-center/";

  buildInputs = [
    nodejs
    makeWrapper

    # For node-gyp
    python
  ];

  buildPhase = ''
    # We already have `node_modules` in the current directory but we
    # need it's binaries on `PATH` so we can use them!
    export PATH="./node_modules/.bin:$PATH"

    # Prevent npm from checking for updates
    export NO_UPDATE_NOTIFIER=true

    # The order of `npm` commands matches what `npm run build-prod` does but we split
    # it out so we can customise the native builds in `npm run build-service`.
    npm run clean
    npm run build-electron

    # We don't use `npm run build-service` here because it uses `pkg` which packages
    # node binaries in a way unsuitable for nix. Instead we're doing it ourself.
    tsc -p ./src/service-app
    cp ./src/package.json ./dist/tuxedo-control-center/service-app/package.json

    # We need to tell npm where to find node or `node-gyp` will try to download it.
    # This also _needs_ to be lowercase or `npm` won't detect it
    export npm_config_nodedir=${nodejs}
    npm run build-native   # Builds to ./build/Release/TuxedoWMIAPI.node

    npm run build-ng-prod
  '';

  installPhase = ''
    mkdir -p $out
    cp -R ./dist/tuxedo-control-center/* $out

    ln -s $src/node_modules $out/node_modules

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
    #
    # We use `--no-tccd-version-check` because the app uses the electron context
    # to determine the app version, but the electron context is wrong if electron
    # is invoked directly on a JavaScript file.
    #
    # The fix is to run electron on a folder with a `package.json` but the `tuxedo-control-center`
    # package.json expects all files to live under `dist/` and I'm not a huge fan of that
    # structure so we just disable the check and call it a day.
    makeWrapper ${electron_8}/bin/electron $out/bin/tuxedo-control-center \
                --add-flags "$out/e-app/e-app/main.js" \
                --add-flags "--no-tccd-version-check" \
                --prefix NODE_PATH : $out/node_modules

    mkdir -p $out/share/polkit-1/actions/
    cp $out/data/dist-data/de.tuxedocomputers.tcc.policy $out/share/polkit-1/actions/de.tuxedocomputers.tcc.policy

    mkdir -p $out/etc/dbus-1/system.d/
    cp $out/data/dist-data/com.tuxedocomputers.tccd.conf $out/etc/dbus-1/system.d/com.tuxedocomputers.tccd.conf

    # Put our icons in the right spot
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp $out/data/dist-data/tuxedo-control-center_256.svg \
       $out/share/icons/hicolor/scalable/apps/tuxedo-control-center.svg

    ${desktopItem.buildCommand}
  '';
}
