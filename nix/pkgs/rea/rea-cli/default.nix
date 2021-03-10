{ stdenv, makeWrapper }:

stdenv.mkDerivation rec {
  version = "cb4f634f638a5e21f7c4249eaac6050e0a951734"; # rea-cli uses the git sha as it's version
  baseName = "rea-cli";
  name = "${baseName}-${version}";

  # Private modules work best with builtins.fetchGit instead of fetchgit.
  # Make sure to use the `ssh://` style as it seems to be the only one that
  # works with your user's ssh config
  #
  # Note: When updating, first run `nixos-rebuild build` then `sudo -E nixos-rebuild switch`
  src = builtins.fetchGit {
    url = ssh://git@git.realestate.com.au/rea-cli/rea-cli.git;
    rev = "cb4f634f638a5e21f7c4249eaac6050e0a951734";
  };

  nativeBuildInputs = [ makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    cp -r "${src}" $out
    chmod -R +w $out       # out needs to be writable while we manipulate it

    # We don't need the `README` and `docs` folder and they collide with other derivations that also have `README` or `docs`
    rm -rf $out/docs
    rm $out/README.md

    wrapProgram $out/bin/rea \
      --add-flags "--disable-auto-update" 
  '';
}
