{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/nixos
    ./secrets.nix
    ./gpu-configuration.nix
    ./hardware-configuration.nix
  ];

  programs.nih.enable = true;
  programs.nih.flakeDir = "/home/guz/.nix";
  programs.nih.host = "battleship";

  profiles.locale.enable = true;

  programs.hyprland.enable = true;
  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    fira-code
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];

  home-manager-helper.enable = true;
  home-manager-helper.users."guz" = {
    name = "guz";
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$J7gmdB306rufrjdsY5kJq0$spluDZf8jEkG0VYcZXzBIpnACVIk27C8YTbo2vbNFfA";
    home = import ./home.nix;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  # hardware.pulseaudio.enable = true;

  services.interception-tools = let
    device = "/dev/input/by-id/usb-BY_Tech_Gaming_Keyboard-event-kbd";
  in {
    enable = true;
    plugins = [pkgs.interception-tools-plugins.caps2esc];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g ${device} | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 2 | ${pkgs.interception-tools}/bin/uinput -d ${device}"
        DEVICE:
          EVENTS:
            EV_KEY: [[KEY_CAPSLOCK, KEY_ESC]]
          LINK: ${device}
    '';
  };

  environment.pathsToLink = [" /share/zsh "];

  programs.zsh.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [];

  networking = {
    networkmanager.enable = true;
    hostName = "battleship";
    wireless.enable = false;
    dhcpcd.enable = true;
    defaultGateway = "192.168.1.1";
    interfaces."enp6s0".ipv4.addresses = [
      {
        address = "192.168.1.13";
        prefixLength = 24;
      }
    ];
    nameservers = ["8.8.8.8" "1.1.1.1"];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    #jack.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}