{ config, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    firefox
    termite
    networkmanagerapplet
    xscreensaver
    rofi
  ];

  services.xserver = {
    enable = true;
    exportConfiguration = true;

    displayManager.sddm.enable = true;
    desktopManager.xfce4-14.enable = true;

  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

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
      emacs-all-the-icons-fonts
    ];
  };
}
