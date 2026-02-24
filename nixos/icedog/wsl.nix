{
  config,
  lib,
  pkgs,
  ...
}:

{
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
    home-manager
    # docker
  ];
  security.pki.certificates = [
    (builtins.readFile /home/tkcd/cert/zscaler.crt)
    (builtins.readFile /home/tkcd/cert/agcglobal.cer)
  ];
  virtualisation.docker = {
    enable = true;
  };
  users.users.tkcd = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
  time.timeZone = "Asia/Tokyo";
  wsl.enable = true;
  wsl.defaultUser = "tkcd";
  wsl.wslConf.interop = {
    enabled = false;
    appendWindowsPath = false;
  };
  wsl.wslConf.network.hostname = "icedog";
  system.stateVersion = "25.11"; # Did you read the comment?
}
