{
  description = "NixOS & Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    gfm-preview.url = "github:thiagokokada/gh-gfm-preview";
    codex-cli.url = "github:sadjow/codex-cli-nix";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      claude-code,
      codex-cli,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsWithClaude = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ claude-code.overlays.default ];
      };
      pkgsCodex = codex-cli.packages.${system}.default;
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
        "tkcd@company-laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsWithClaude;
          modules = [
            ./hosts/company-laptop.nix
            {
              home.packages = [
                pkgsWithClaude.claude-code
                pkgsCodex
              ];
            }
          ];
        };
      };
    };
}
