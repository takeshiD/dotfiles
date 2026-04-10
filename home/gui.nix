{ pkgs, inputs, ... }:
let
  browserPkgs = with pkgs; [
    google-chrome
    vivaldi
  ];
  terminalEnumulatorPkgs = with pkgs; [
    ghostty
    wezterm
  ];
  miscPkgs = with pkgs; [
    slack
    discord
    obsidian
    fontforge-gtk
    foliate
  ];
in
{
  home.packages = browserPkgs ++ terminalEnumulatorPkgs ++ miscPkgs;
  nixpkgs.config.allowUnfree = true;
}
