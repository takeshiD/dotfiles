{ pkgs, inputs, ... }:
let
  browserPkgs = with pkgs; [
    google-chrome
    vivaldi
  ];
  terminalEnumulatorPkgs = with pkgs; [
    ghostty
  ];
  miscPkgs = with pkgs; [
    slack
    # discord
  ];
in
{
  home.packages = browserPkgs ++ terminalEnumulatorPkgs ++ miscPkgs;
  nixpkgs.config.allowUnfree = true;
}
