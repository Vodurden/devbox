{ config, lib, pkgs, ... }:

{
  emacs,
  doom,
  doomLocalDir,
}:

let
  doomChange = pkgs.writeShellScriptBin "doom-change" ''
    export DOOMLOCALDIR="${doomLocalDir}"
    if [ ! -d "$DOOMLOCALDIR" ]; then
      ${doom}/bin/doom -y sync
      ${doom}/bin/doom -y env
    else
      ${doom}/bin/doom -y sync
    fi
  '';
in

pkgs.buildEnv {
  name = "doom-emacs-wrapped";
  paths = [ emacs doomChange ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  pathsToLink = [
    # Deep-link /share/applications so we can delete things from it.
    #
    # Otherwise /share/applications is a symlink and we can't touch it.
    "/share/applications"
    "/"
  ];
  postBuild = ''
    for exe in $out/bin/*; do
      wrapProgram "$exe" --set DOOMLOCALDIR ${doomLocalDir}
    done

    makeWrapper ${doom}/bin/doom $out/bin/doom \
      --set DOOMLOCALDIR ${doomLocalDir}

    rm $out/share/applications/emacs.desktop
    rm $out/share/applications/emacs-mail.desktop
  '';
}
