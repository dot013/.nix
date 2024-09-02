{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.dot013-environment.nixosModules.default
    ../../modules/nixos
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  dot013.environment.enable = true;
  dot013.environment.interception-tools.device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

  programs.nh.enable = true;
  programs.nh.flake = "/home/guz/nix";

  profiles.locale.enable = true;

  virtualisation.docker.enable = true;

  programs.dconf.enable = true;

  programs.hyprland.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    settings = {
      default-cache-ttl = 3600 * 24;
    };
  };

  services.xserver = {
    enable = true;
  };
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  services.tailscale = {
    enable = true;
    tailnetName = "kiko-liberty";
  };

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    fira-code
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];

  home-manager-helper.enable = true;
  home-manager-helper.users."guz" = {
    name = "guz";
    shell = pkgs.zsh;
    hashedPasswordFile = builtins.toString config.sops.secrets."guz/password".path;
    home = import ./home.nix;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "plugdev"];
  };

  environment.systemPackages = with pkgs; [
    git
    libinput
    polkit_gnome
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  # hardware.pulseaudio.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.package = pkgs.nixVersions.nix_2_21;

  networking = {
    networkmanager.enable = true;
    hostName = "fighter";
    wireless.enable = false;
    dhcpcd.enable = true;
    defaultGateway = "192.168.1.1";
    interfaces."enp6s0".ipv4.addresses = [
      {
        address = "192.168.1.7";
        prefixLength = 24;
      }
    ];
    nameservers = ["8.8.8.8" "1.1.1.1"];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
