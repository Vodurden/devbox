{ config, lib, pkgs, ... }:

let
  # adapted from `nix run github:nix-community/pip2nix generate pyyaml==5.4.1 anytree==2.8.0`
  anytree280 = pkgs.pythonPackages.buildPythonPackage rec {
    pname = "anytree";
    version = "2.8.0";

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/a8/65/be23d8c3ecd68d40541d49812cd94ed0f3ee37eb88669ca15df0e43daed1/anytree-2.8.0-py2.py3-none-any.whl";
      sha256 = "088mwcyrh7kv6cp03ai21giwf51xfwxs0jah74r1bccjfk3mmi8l";
    };
    format = "wheel";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [
      six116
    ];
  };

  pyyaml541 = pkgs.pythonPackages.buildPythonPackage rec {
    pname = "pyyaml";
    version = "5.4.1";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz";
      sha256 = "0pm440pmpvgv5rbbnm8hk4qga5a292kvlm1bh3x2nwr8pb5p8xv0";
    };
    format = "setuptools";
    doCheck = false;
    buildInputs = [];
    checkInputs = [];
    nativeBuildInputs = [];
    propagatedBuildInputs = [];
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
      cp -r ${anytree280}/lib/python2.7/site-packages/* "$out/lib/ghidra/Ghidra/Features/Python/data/jython-2.7.3/Lib/site-packages/"
      cp -r ${pyyaml541}/lib/python2.7/site-packages/* "$out/lib/ghidra/Ghidra/Features/Python/data/jython-2.7.3/Lib/site-packages/"
      cp -r ${six116}/lib/python2.7/site-packages/* "$out/lib/ghidra/Ghidra/Features/Python/data/jython-2.7.3/Lib/site-packages/"
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
