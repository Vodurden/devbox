{ config, lib, pkgs, ... }:

let
  # adapted from `nix run github:nix-community/pip2nix generate pyyaml==5.4.1 anytree`
  pyyaml541 = pkgs.pythonPackages.buildPythonPackage rec {
    pname = "pyyaml";
    version = "5.4.1";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e";
    };
    format = "setuptools";
    nativeBuildInputs = [ pkgs.pythonPackages.cython pkgs.buildPackages.stdenv.cc ];
    buildInputs = [ pkgs.libyaml ];
  };

  six116 = pkgs.pythonPackages.buildPythonPackage rec {
    pname = "six";
    version = "1.16.0";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/d9/5a/e7c31adbe875f2abbb91bd84cf2dc52d792b5a01506781dbcf25c91daf11/six-1.16.0-py2.py3-none-any.whl";
      sha256 = "0m02dsi8lvrjf4bi20ab6lm7rr6krz7pg6lzk3xjs2l9hqfjzfwa";
    };
    format = "wheel";
    doCheck = false;
  };

in

{
  # We need extra python packages in ghidra, but since they need to be in the nix
  # directory we hack it into the package directly
  nixpkgs.overlays = [(self: super: {
    ghidra = super.ghidra.overrideAttrs(oldAttrs: rec {
      postFixup = oldAttrs.postFixup + ''
      cp -r ${pkgs.python2.pkgs.anytree}/lib/python2.7/site-packages/* $out/lib/ghidra/Ghidra/Features/Python/data/jython-*/Lib/site-packages/
      cp -r ${pyyaml541}/lib/python2.7/site-packages/* $out/lib/ghidra/Ghidra/Features/Python/data/jython-*/Lib/site-packages/
      cp -r ${six116}/lib/python2.7/site-packages/* $out/lib/ghidra/Ghidra/Features/Python/data/jython-*/Lib/site-packages/
      '';
    });
  })];

  environment.variables.GHIDRA_HOME=pkgs.ghidra;

  environment.systemPackages = [
    pkgs.ghidra
    (pkgs.unstable.cutter.withPlugins (plugins: [plugins.rz-ghidra]))
    pkgs.ffxiv-cexporter
    pkgs.pkgsCross.mingwW64.buildPackages.gdb
  ];
}
