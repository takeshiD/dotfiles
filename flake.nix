{
  description = "NixOS & Home Manager configuration";
  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    gfm-preview.url = "github:thiagokokada/gh-gfm-preview";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        "snowcat" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/snowcat
          ];
        };
        "icedog" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/icedog
          ];
        };
      };
      homeConfigurations = {
        "tkcd@snowcat" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/snowcat.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        # Company Laptop
        "tkcd@americano" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/americano.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        "tkcd@espresso" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/espresso.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        "tkcd@icedog" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/icedog.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
