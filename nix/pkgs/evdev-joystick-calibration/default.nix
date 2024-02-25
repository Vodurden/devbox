{ config, lib, pkgs, fetchurl, python3Packages, ... }:

let
  evdev130 = pkgs.python3Packages.evdev.overrideAttrs(oldAttrs: rec {
    version = "1.3.0";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/89/83/5f5635fd0d91a08ac355dd9ca9bde34bfa6b29a5c59f703ad83d1ad0bf34/evdev-1.3.0.tar.gz";
      sha256 = "0kb3636yaw9l8xi8s184w0r0n9ic5dw3b8hx048jf9fpzss4kimi";
    };
  });
in

python3Packages.buildPythonApplication rec {
  name = "evdev-joystick-calibration";
  version = "0.1.1";

  propagatedBuildInputs = [
    evdev130
  ];

  # TODO: Move to the real repo when merged: https://github.com/nick-l-o3de/evdev-joystick-calibration/pull/1
  src = pkgs.fetchFromGitHub {
    owner = "Vodurden";
    repo = "evdev-joystick-calibration";
    rev = "9031aa7534be0c2595f3dfa617c364121f8920b8";
    sha256 = "sha256-QD4UKzr4VkZaZwz7r4I5fQzCUDZPbEvvxDT+cXqI/r0=";
  };
}
