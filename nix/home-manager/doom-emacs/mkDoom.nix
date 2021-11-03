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

pkgs.symlinkJoin {
  name = "doom-emacs-wrapped";
  paths = [ emacs doomChange ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/emacs \
      --set DOOMLOCALDIR ${doomLocalDir}

    wrapProgram "$out/bin/emacs-${lib.getVersion emacs}" \
      --set DOOMLOCALDIR ${doomLocalDir}

    wrapProgram $out/bin/emacsclient \
      --set DOOMLOCALDIR ${doomLocalDir}

    makeWrapper ${doom}/bin/doom $out/bin/doom \
      --set DOOMLOCALDIR ${doomLocalDir}
  '';
}
