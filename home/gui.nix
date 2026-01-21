{ pkgs, inputs, ... }:
let
  browserPkgs = with pkgs; [
    google-chrome
  ];
  terminalPkgs = with pkgs; [
    ghostty
  ];
in
{
  home.packages = browserPkgs ++ terminalPkgs;
  nixpkgs.config.allowUnfree = true;
}
