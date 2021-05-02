#!/usr/bin/env bash
nix-shell -p '(steam.override { extraLibraries = (pkgs: [ pkgs.openssl pkgs.nghttp2 pkgs.libidn2 pkgs.rtmpdump pkgs.libpsl pkgs.curl pkgs.krb5 pkgs.keyutils ]); }).run' --command "steam-run ./Loop_Hero"
