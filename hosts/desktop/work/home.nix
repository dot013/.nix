{ config, pkgs, inputs, ... }:

{
  imports = [
    ../shared-home.nix
  ];

  theme.accent = "94e2d5";
}
