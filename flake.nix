{
  description = "NixOS & Home Manager configuration";
  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://ros.cachix.org"
      "https://takeshid.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      "takeshid.cachix.org-1:2GsGTUZ3djVzbGzXgeia+SRV1ZJYOXySHyNfBPsEjRA="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-deck.url = "github:takeshid/tmux-deck";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    gfm-preview.url = "github:thiagokokada/gh-gfm-preview";
    llm-agents.url = "github:numtide/llm-agents.nix";
    # bacon-ls.url = "github:crisidev/bacon-ls";
    ob-fish.url = "github:takeshid/ob.fish";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
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
            nixos-wsl.nixosModules.wsl
            ./nixos/icedog
          ];
        };
        "samoyed" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-wsl.nixosModules.wsl
            ./nixos/samoyed
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
        "tkcd@cafelatte" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/cafelatte.nix
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
        "tkcd@samoyed" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/samoyed.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        "tkcd@doppio" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/doppio.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
