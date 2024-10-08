{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [];

  librewolf = {
    enable = true;
    profiles = {
      guz = {
        id = 0;
        settings = {
          "webgl.disabled" = false;
          "browser.startup.homepage" = "https://search.brave.com";
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "privacy.clearOnShutdown.cookies" = false;
        };
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          canvasblocker
          clearurls
          darkreader
          facebook-container
          libredirect
          multi-account-containers
          simplelogin
          smart-referer
          sponsorblock
          tridactyl
          ublock-origin
        ];
      };
    };
  };

  programs.krita.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  home.packages = with pkgs; [
    ## Programs
    vesktop
    pavucontrol
    pinentry
    gnome.nautilus

    ## Fonts
    fira-code
    (nerdfonts.override {fonts = ["FiraCode"];})

    blutuith
  ];
}
