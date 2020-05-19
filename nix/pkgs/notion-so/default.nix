{ stdenv, fetchurl, makeDesktopItem,

  undmg, electron_6,
}:

let
  baseName = "notion-so";
  version = "2.0.7";

  desktopItem = makeDesktopItem {
    name = "notion";
    exec = "notion-so";
    comment = "Unofficial Notion.so application for Linux";
    icon = ./notion_app_logo.png;
    desktopName = "Notion";
    categories = "Office;TextEditor;Utility";
    extraEntries = ''
      StartupWMClass=notion
      MimeType=x-scheme-handler/notion;
    '';
  };

in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://desktop-release.notion-static.com/Notion-${version}.dmg";
    sha256 = "0rjinvw4ldbmb2ccsw42crkvi9b5q7ci8z3n87fcfi6mi3q5v4a8";
  };

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    cp -r . $out

    mkdir -p "$out/bin"
    mkdir -p "$out/notion-so"

    cp -r ./Contents/Resources/* $out/notion-so

    cat > "$out/bin/${baseName}" << EOF
    #!${stdenv.shell}

    pushd "$out/notion-so" >/dev/null || exit 1
    ${electron_6}/bin/electron $out/notion-so/app.asar
    popd >/dev/null || exit 1
    EOF

    chmod +x "$out/bin/${baseName}"

    ${desktopItem.buildCommand}
  '';
}
