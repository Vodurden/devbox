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
    rev = "72b6ceb8d4be917f54f1ecb1bb6952e88144db01";
    sha256 = "sha256-S9Y03xjFsM8+5i3++bUky+AyybAzUMx9Ny+DNNaz4U0=";
  };
}
