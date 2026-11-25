{
  pkgs,
  ...
}:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    # ./wireguard.nix
  ];
  services.obsidian-ai-workflow.enable = true;
}
