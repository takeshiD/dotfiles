{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];
  nix.settings = {
    trusted-users = [
      "root"
      "tkcd"
    ];
    substituters = [
      "https://cache.numtide.com"
    ];
    trusted-substituters = [ ];
    trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    git
  ];

  wsl.enable = true;
  wsl.defaultUser = "tkcd";
  wsl.interop.enabled = false;
  wsl.wslConf.hostname = "icedog";
  system.stateVersion = "25.11"; # Did you read the comment?
}
