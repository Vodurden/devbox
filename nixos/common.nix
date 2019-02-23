{ config, pkgs, ... }:

let
  baseConfig = {
    allowUnfree = true;

    wine.build = "wineWow";
    wineUnstable.build = "wineWow";
  };

  unstable = import <nixpkgs-unstable> { config = baseConfig; };
in
{
  # Internationalisation
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Australia/Sydney";

  nixpkgs.config = baseConfig;

  nix.nixPath = [
    "nixpkgs=/nix/nixpkgs"
    "nixpkgs-unstable=/nix/nixpkgs-unstable"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  services.nixosManual.showManual = true;

  environment.systemPackages = with pkgs; [
    acpi
    wget
    git

    # X packages
    acpi
    xclip
    chromium
    firefox
    rxvt_unicode-with-plugins
    termite
    dmenu
    feh
    fontconfig
    xorg.xev
    xbindkeys
    xautomation
    evtest

    ntfs3g

    haskellPackages.xmobar

    # Unstable steam fixes the friends issue. Switch back for 19.03
    unstable.steam
    calibre
    libreoffice
    partition-manager
    gparted
    pinta
  ];

  # Enable DBus
  services.dbus.enable = true;

  # Replace nptd by timesyncd
  services.timesyncd.enable = true;

  fonts = {
    fontconfig = {
      dpi = 96;
      subpixel.rgba = "rgb";
      enable = true;
      antialias = true;
      hinting.enable = true;
    };

    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      emojione
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira
      fira-code
      fira-mono
      font-droid

      hack-font
      terminus_font
      anonymousPro
      freefont_ttf
      corefonts
      dejavu_fonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      ubuntu_font_family
      ttf_bitstream_vera
    ];
  };

  # Define our user accounts. Don't forget to set a password with `passwd`
  users.extraUsers.jake = {
    extraGroups = [ "wheel" "audio" "networkmanager" "dialout" ];
    isNormalUser = true;
    uid = 1000;
  };
}
