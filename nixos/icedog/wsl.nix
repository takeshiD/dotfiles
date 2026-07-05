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
    docker
    tailscale
    gh-markdown-preview
  ];
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  programs.nix-ld.enable = true;
  security.pki.certificates = [
  ];
  # networking.enableIPv6 = false;
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
    enabled = true;
    appendWindowsPath = false;
  };
  wsl.useWindowsDriver = true;
  wsl.wslConf.network.hostname = "icedog";
  system.stateVersion = "26.11"; # Did you read the comment?
}
