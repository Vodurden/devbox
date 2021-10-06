{ pkgs, newScope, buildFHSUserEnvBubblewrap, e9patch }:

let
  callPackage = newScope self;

  self = rec {
    mudfish = callPackage ./mudfish.nix { inherit e9patch; };
    mudfish-fhsenv = callPackage ./fhsenv.nix { inherit buildFHSUserEnvBubblewrap; };
  };
in self

  # [30.95] ICMP echo feature must run as root
  # Mon, 04 Oct 2021 04:22:47 GMT [2.486251] [CRIT] Assert (ioctl(fd, TUNSETIFF, (void *) &ifr) == 0) failed at ODR_open_tuntapdev (./mud/os/linux/syscalls.c:745) with 0
  # Mudfish runs
  # ip , kmod-tun , libopenssl , libpthread , librt , and zlib
