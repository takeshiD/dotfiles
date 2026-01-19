{
  description = "NixOS & Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gfm-preview.url = "github:thiagokokada/gh-gfm-preview";
    codex-cli.url = "github:sadjow/codex-cli-nix";
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        "dev-laptop" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/configuration.nix
          ];
        };
      };
      homeConfigurations = {
        "tkcd@dev-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/dev-laptop.nix ];
        };
      };
      homeConfigurations = {
        "tkcd@company-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/company-laptop.nix ];
        };
      };
    };
}
