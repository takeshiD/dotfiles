{
  description = "NixOS & Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    gfm-preview.url = "github:thiagokokada/gh-gfm-preview";
    codex-cli.url = "github:sadjow/codex-cli-nix";
    claude-code.url = "github:sadjow/claude-code-nix";
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
        "dev-laptop" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/dev-laptop
          ];
        };
      };
      homeConfigurations = {
        "tkcd@dev-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/dev-laptop.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        "tkcd@company-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/company-laptop.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
