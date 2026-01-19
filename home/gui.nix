{ pkgs, inputs, ... }:
let
  browserPkgs = with pkgs; [
    google-chrome
  ];
  terminalPkgs = with pkgs; [
    ghostty
  ];
  # wmPkgs = with pkgs; [
  #   hyprland
  # ];
in
{
  home.packages = browserPkgs ++ terminalPkgs;
  nixpkgs.config.allowUnfree = true;
}
