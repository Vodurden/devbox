{ config, lib, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [
      # When TZ is set XIV will display incorrect Local Time and Server Time
      (pkgs.xivlauncher.override {
        steam = pkgs.steam.override {
          extraProfile = ''
            unset TZ
            export CHROME_PATH=pkgs.chromium;
          '';
        };
      })

      pkgs.fflogs-uploader
    ];
  };

  ### Additional steps for getting IINACT running
  ###
  ### 1. Make sure WinPcap is installed in the .xlcore prefix:
  ###
  ###     wget -O ~/.xlcore/wineprefix/drive_c/WinPcap_4_1_3.exe https://www.winpcap.org/install/bin/WinPcap_4_1_3.exe
  ###     Open XIVLauncher > Wine > Open Wine Explorer (run apps in prefix) > Navigate to the WinPcap installer and install it
  ###     Open XIVLauncher > Wine > Wine Configuration > Libraries >  Add `wpcap` as an override
  ###
  ### 2. Install IINACT
  ###
  ###    wget -O ~/.xlcore/wineprefix/drive_c/IINACT.zip https://github.com/marzent/IINACT/releases/download/v0.4.2/IINACT.zip
  ###    unzip ~/.xlcore/wineprefix/drive_c/IINACT.zip -d ~/.xlcore/wineprefix/drive_c/

  # For IINACT we need rpcapd which means we need to build libpcap with "--enable-remote"
  environment.systemPackages = [
    pkgs.rpcapd
    pkgs.gnutls
  ];

  nixpkgs.overlays = [(self: super: {
    # We don't override libpcap directly since then everything needs to rebuild, and we really just want the binary
    rpcapd = super.libpcap.overrideAttrs(final: prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.libxcrypt ];
      configureFlags = prev.configureFlags ++ ["--enable-remote"];
    });
  })];

  # steam-run needs to include gnutls for iinact to work
  # programs.steam.package = pkgs.steam.override {
  #   extraLibraries = pkgs:
  #     if pkgs.stdenv.hostPlatform.is64bit
  #     then [ config.hardware.opengl.package ] ++ config.hardware.opengl.extraPackages ++ [ pkgs.gnutls ]
  #     else [ config.hardware.opengl.package32 ] ++ config.hardware.opengl.extraPackages32 ++ [ pkgs.gnutls ];
  # };

  security.wrappers.rpcapd = {
    source = "${pkgs.rpcapd}/bin/rpcapd";
    capabilities = "cap_net_admin,cap_net_raw,cap_sys_ptrace=eip";
    owner = "root";
    group = "root";
  };
}
