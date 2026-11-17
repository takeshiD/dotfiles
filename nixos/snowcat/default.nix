{
  pkgs,
  ...
}:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
  services.obsidian-ai-workflow.enable = true;
}
